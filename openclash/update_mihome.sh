#!/bin/sh
# 推荐在 OpenWrt 下用 ash 运行
# 在线运行命令: curl -sL https://raw.githubusercontent.com/maxage/openclash/main/update_mihome.sh | sh

# 颜色变量
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

# 常量定义
OPENCLASH_DIR="/etc/openclash"
TARGET_DIR="$OPENCLASH_DIR/core"
BACKUP_DIR="$TARGET_DIR/meta-backup"
MAX_BACKUPS=7
RELEASE_URL="https://api.github.com/repos/MetaCubeX/mihomo/releases"
CONFIG_DIR="$OPENCLASH_DIR"
TOKEN_FILE="$CONFIG_DIR/.github_token"
LAST_CONFIG_FILE="$CONFIG_DIR/.mihomo_last_choice"
DIVIDER="${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
VERSION="1.0.1"

# 工具函数
print_divider() {
    echo -e "$DIVIDER"
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

print_error() {
    echo -e "${RED}✖ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✔ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# 检查 OpenClash 是否安装
check_openclash() {
    if [ ! -d "$OPENCLASH_DIR" ]; then
        print_error "未检测到 OpenClash 安装目录 ($OPENCLASH_DIR)"
        echo -e "${YELLOW}请确认您已安装 OpenClash。如未安装，请先安装后再使用本脚本。${NC}"
        exit 1
    fi
    
    if [ ! -d "$TARGET_DIR" ]; then
        mkdir -p "$TARGET_DIR"
        if [ $? -ne 0 ]; then
            print_error "无法创建 $TARGET_DIR 目录，请检查权限"
            exit 1
        fi
    fi
}

# 检查磁盘空间
check_disk_space() {
    local free_space
    free_space=$(df -m "$TARGET_DIR" | awk 'NR==2 {print $4}')
    if [ "$free_space" -lt 20 ]; then
        print_warning "磁盘空间不足（小于20MB），可能影响下载和解压"
        echo -e "${YELLOW}建议清理磁盘空间后再运行${NC}"
    fi
}

# 输出Logo和使用说明
show_logo() {
    clear
    echo -e "${CYAN}${BOLD}     Mihomo (Clash.Meta) 内核自动更新脚本 v$VERSION     ${NC}"
    echo -e "${YELLOW}作者:   https://github.com/MetaCubeX${NC}"
    echo -e "${YELLOW}脚本:   https://github.com/maxage/openclash${NC}"
    print_divider
}

show_usage() {
    print_divider
    echo -e "【使用说明】"
    echo -e "1. 本脚本用于自动下载并更新 Mihomo (Clash.Meta) 内核。"
    echo -e "2. 仅支持 Prerelease-Alpha 版本，支持多平台多架构。"
    echo -e "3. 请选择'手动分级选择'，依次选择操作系统、架构、编译方式、具体包。"
    echo -e "4. 下载后会自动备份原 clash_meta 文件，保留7个备份。"
    echo -e "5. 如遇网络问题、API限流、GitHub被墙等，脚本会提示错误。"
    echo -e "6. 本脚本只适用于OpenWrt中的OpenClash使用。"
    echo -e "7. 如有疑问请访问作者主页或脚本主页。"
    print_divider
}

# 检查并安装依赖
check_dependencies() {
    # 检查是否为 root
    if [ "$(id -u)" -ne 0 ]; then
        print_error "请用 root 权限运行本脚本。"
        echo -e "${YELLOW}可以使用以下命令：${NC}"
        echo -e "${CYAN}curl -sL https://raw.githubusercontent.com/maxage/openclash/main/update_mihome.sh | sudo sh${NC}"
        exit 1
    fi

    # 检查是否安装了 OpenClash
    check_openclash
    
    # 检查 opkg 是否存在
    if ! check_command opkg; then
        print_error "未检测到 opkg，请手动安装 curl、jq、gzip 后再运行本脚本。"
        exit 1
    fi

    # 创建目录
    mkdir -p "$BACKUP_DIR" "$CONFIG_DIR"

    # 检查目录权限
    if [ ! -w "$TARGET_DIR" ]; then
        print_error "没有足够的权限在 $TARGET_DIR 目录下进行操作，请检查权限设置。"
        exit 1
    fi

    # 检查磁盘空间
    check_disk_space

    # 检查并自动安装依赖
    local need_update=false
    for tool in curl jq gunzip; do
        if ! check_command "$tool"; then
            echo -e "${YELLOW}➜ $tool 未安装，正在尝试自动安装...${NC}"
            if [ "$need_update" = false ]; then
                opkg update
                need_update=true
            fi
            
            if [ "$tool" = "gunzip" ]; then
                opkg install gzip
            else
                opkg install "$tool"
            fi
            
            if ! check_command "$tool"; then
                print_error "$tool 安装失败，请手动安装后重试。"
                exit 1
            fi
            print_success "$tool 安装成功"
        fi
    done
}

# GitHub API请求处理
get_github_releases() {
    local token=""
    local curl_opts="-s"
    
    # 检查是否存在GitHub Token
    if [ -f "$TOKEN_FILE" ]; then
        token=$(cat "$TOKEN_FILE")
        if [ -n "$token" ]; then
            curl_opts="$curl_opts -H \"Authorization: token $token\""
        fi
    fi
    
    print_info "正在获取 GitHub 发布信息，这可能需要一些时间..."
    
    # 通过eval运行带有动态选项的curl命令
    ALL_URLS_RAW=$(eval curl $curl_opts $RELEASE_URL)
    
    # 检查API响应
    if ! echo "$ALL_URLS_RAW" | jq empty 2>/dev/null; then
        print_error "无法获取 GitHub 版本信息，可能是网络问题、被墙或API限流。"
        echo -e "${YELLOW}请检查网络，或稍后重试。${NC}"
        echo -e "${YELLOW}推荐使用科学上网或设置 GitHub Token。${NC}"
        exit 1
    fi
    
    # 检查API限流
    if echo "$ALL_URLS_RAW" | grep -q 'API rate limit exceeded'; then
        print_error "GitHub API 已被限流。"
        echo -e "${YELLOW}解决方法："
        echo -e "1. 等待1小时后自动恢复额度"
        echo -e "2. 设置GitHub Token (选项3)"
        echo -e "3. 更换出口IP${NC}"
        
        # 提示用户设置Token
        echo -ne "${CYAN}是否要设置GitHub Token? (y/n): ${NC}"
        read -r set_token
        if [ "$set_token" = "y" ] || [ "$set_token" = "Y" ]; then
            echo -ne "${CYAN}请输入GitHub Token: ${NC}"
            read -r github_token
            echo "$github_token" > "$TOKEN_FILE"
            chmod 600 "$TOKEN_FILE"
            print_success "Token已保存，重新运行脚本以使用"
        fi
        exit 1
    fi
    
    print_success "GitHub 发布信息获取成功"
    
    # 提取URL
    ALL_URLS=$(echo "$ALL_URLS_RAW" | jq -r '.[] | select(.prerelease == true) | .assets[].browser_download_url')
    ALL_GZ=$(echo "$ALL_URLS" | grep -E '\.gz$')
    
    if [ -z "$ALL_GZ" ]; then
        print_error "未找到任何 .gz 包。"
        exit 1
    fi
    
    echo "$ALL_GZ"
}

# 菜单选择函数
show_menu() {
    local options="$1"
    local prompt="$2"
    local colors="$3"
    local return_var="$4"
    local idx=1
    
    for option in $options; do
        local color=$(get_color $idx "$colors")
        echo -e "${color}  $idx. $option${NC}"
        eval "${return_var}_$idx=\"$option\""
        idx=$((idx+1))
    done
    
    echo -e "${YELLOW}  0. 返回上一级${NC}"
    print_divider
    echo -ne "${CYAN}${prompt}${NC}"
    read -r selected_idx
    
    if [ "$selected_idx" = "0" ]; then
        eval "$return_var=\"\""
        return 1
    fi
    
    eval "selected_option=\$${return_var}_$selected_idx"
    if [ -z "$selected_option" ]; then
        print_error "无效选择，请重试。"
        return 1
    fi
    
    eval "$return_var=\"\$selected_option\""
    return 0
}

get_color() {
    local idx=$1
    local colors="$2"
    set -- $colors
    eval echo \${$(( (idx-1) % $# + 1 ))}
}

# 下载和安装
download_and_install() {
    local download_url="$1"
    local fname=$(basename "$download_url")
    
    print_divider
    echo -e "${BOLD}${GREEN}🎯 已选择：${CYAN}$fname${NC}"
    print_divider
    
    # 保存当前选择
    echo "$download_url" > "$LAST_CONFIG_FILE"
    
    # 下载文件
    echo -e "${BLUE}正在下载: $download_url${NC}"
    if ! curl --retry 3 --retry-delay 2 -# -L "$download_url" -o "$TARGET_DIR/mihomo_latest.gz"; then
        print_error "下载失败，请检查网络连接。"
        exit 1
    fi
    print_success "下载完成"
    
    print_divider
    
    # 备份原有文件
    if [ -f "$TARGET_DIR/clash_meta" ]; then
        local timestamp=$(date +%Y%m%d%H%M%S)
        local backup_file="$BACKUP_DIR/clash_meta_$timestamp"
        cp "$TARGET_DIR/clash_meta" "$backup_file"
        print_success "已备份原有的 clash_meta 文件到 $backup_file"
        
        # 清理旧备份
        local num_backups=$(ls -1 "$BACKUP_DIR" | wc -l)
        if [ "$num_backups" -gt "$MAX_BACKUPS" ]; then
            local oldest_backup=$(ls -1t "$BACKUP_DIR" | tail -n 1)
            rm "$BACKUP_DIR/$oldest_backup"
            print_warning "备份数量超过 $MAX_BACKUPS 个，已删除最旧的备份：$oldest_backup"
        fi
    fi
    
    print_divider
    
    # 删除旧文件
    rm -f "$TARGET_DIR/clash_meta"
    print_success "已删除原有的 clash_meta 文件"
    
    print_divider
    
    # 解压和安装
    echo -e "${BLUE}正在解压文件...${NC}"
    if ! gunzip -f "$TARGET_DIR/mihomo_latest.gz"; then
        print_error "解压失败，请检查文件完整性。"
        exit 1
    fi
    print_success "解压完成"
    
    mv "$TARGET_DIR/mihomo_latest" "$TARGET_DIR/clash_meta"
    print_success "已将解压后的文件重命名为 clash_meta"
    
    chmod +x "$TARGET_DIR/clash_meta"
    print_success "已为 clash_meta 文件赋予执行权限"
    
    print_divider
    echo -e "${GREEN}🎉 Mihomo (Clash.Meta) 内核更新完成！${NC}"
    print_divider
    echo -e "${GREEN}感谢使用 Mihomo (Clash.Meta) 内核自动更新脚本！${NC}"
}

# 检测系统和架构
detect_system_info() {
    local os=""
    local arch=""
    
    if [ -f "/etc/os-release" ]; then
        os=$(grep -o "^ID=.*" /etc/os-release | cut -d= -f2 | tr -d '"')
    fi
    
    arch=$(uname -m)
    case "$arch" in
        x86_64) arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7*) arch="armv7" ;;
        armv6*) arch="armv6" ;;
        arm) arch="armv5" ;;
        i386|i686) arch="386" ;;
        mips) 
            if lscpu | grep -q "Little Endian"; then
                arch="mipsle"
            else
                arch="mips"
            fi
            ;;
        mips64) 
            if lscpu | grep -q "Little Endian"; then
                arch="mips64le"
            else
                arch="mips64"
            fi
            ;;
    esac
    
    echo "$os $arch"
}

# 主函数
main() {
    show_logo
    show_usage
    check_dependencies
    
    # 定义统一的颜色主题，使界面更美观
    MENU_TITLE_COLOR="${CYAN}${BOLD}"
    MENU_OPTION_COLOR="${BLUE}"
    MENU_CHOICE_COLOR="${CYAN}"
    
    print_divider
    echo -e "${MENU_TITLE_COLOR}请选择你需要下载的内核包${NC}"
    echo -e "${MENU_OPTION_COLOR}  1. 手动分级选择（操作系统 → 架构 → 编译方式 → 包）${NC}"
    echo -e "${MENU_OPTION_COLOR}  2. 检测当前系统和架构 (仅供参考)${NC}"
    echo -e "${MENU_OPTION_COLOR}  3. 设置GitHub Token${NC}"
    echo -e "${MENU_OPTION_COLOR}  4. 退出${NC}"
    print_divider
    echo -ne "${MENU_CHOICE_COLOR}请输入选项（1-4）：${NC}"
    read -r MODE_CHOICE
    
    case "$MODE_CHOICE" in
        1)
            # 获取GitHub发布信息
            print_divider
            echo -e "${BLUE}🌐 正在获取 Prerelease-Alpha 的所有包信息...${NC}"
            ALL_GZ=$(get_github_releases)
            
            # 捕获退出信号，自动清理临时文件
            TMP_LIST=$(mktemp)
            echo "$ALL_GZ" > "$TMP_LIST"
            trap 'rm -f "$TMP_LIST"' EXIT
            
            # 颜色定义 - 使用一致的颜色主题
            OS_COLORS="${BLUE} ${GREEN} ${YELLOW} ${MAGENTA} ${CYAN} ${BLUE} ${GREEN} ${YELLOW}"
            ARCH_COLORS="${BLUE} ${GREEN} ${YELLOW} ${MAGENTA} ${CYAN} ${BLUE} ${GREEN} ${YELLOW}"
            COMP_COLORS="${BLUE} ${GREEN} ${YELLOW} ${MAGENTA} ${CYAN} ${BLUE} ${GREEN} ${YELLOW}"
            
            # 主选择循环
            while true; do
                # 操作系统选择
                OS_LIST=$(awk -F/ '{print $NF}' "$TMP_LIST" | awk -F- '{print $2}' | sort | uniq)
                print_divider
                echo -e "${MENU_TITLE_COLOR}🖥 请选择操作系统：${NC}"
                if ! show_menu "$OS_LIST" "请输入操作系统序号（0退出）：" "$OS_COLORS" "SELECTED_OS"; then
                    [ -z "$SELECTED_OS" ] && echo -e "${YELLOW}👋 已退出，欢迎下次使用！${NC}" && exit 0
                    continue
                fi
                
                # 架构选择
                while true; do
                    ARCH_LIST=$(awk -F/ '{print $NF}' "$TMP_LIST" | awk -F- -v os="$SELECTED_OS" '$2==os{print $3}' | sort | uniq)
                    print_divider
                    echo -e "${MENU_TITLE_COLOR}🔧 请选择架构：${NC}"
                    if ! show_menu "$ARCH_LIST" "请输入架构序号（0返回）：" "$ARCH_COLORS" "SELECTED_ARCH"; then
                        [ -z "$SELECTED_ARCH" ] && break
                        continue
                    fi
                    
                    # 编译方式/Go版本选择
                    while true; do
                        COMPILE_LIST=$(awk -F/ '{print $NF}' "$TMP_LIST" | awk -F- -v os="$SELECTED_OS" -v arch="$SELECTED_ARCH" '$2==os&&$3==arch{for(i=4;i<=NF;i++){if($i ~ /^alpha/) break; if($i ~ /^go[0-9]+$/ || $i=="compatible") print $i}}' | sort | uniq)
                        [ -z "$COMPILE_LIST" ] && COMPILE_LIST="默认"
                        print_divider
                        echo -e "${MENU_TITLE_COLOR}⚙ 请选择编译方式/Go版本：${NC}"
                        if ! show_menu "$COMPILE_LIST" "请输入编译方式序号（0返回）：" "$COMP_COLORS" "SELECTED_COMP"; then
                            [ -z "$SELECTED_COMP" ] && break
                            continue
                        fi
                        
                        # 包选择
                        print_divider
                        echo -e "${MENU_TITLE_COLOR}📦 可用包如下：${NC}"
                        IDX=1
                        while IFS= read -r line; do
                            fname=$(basename "$line")
                            os=$(echo "$fname" | awk -F- '{print $2}')
                            arch=$(echo "$fname" | awk -F- '{print $3}')
                            comp=$(echo "$fname" | awk -F- '{if(NF>=5 && $4!~"alpha" && $4!~"go[0-9]+$") print $4; else print "默认"}')
                            if [ "$os" = "$SELECTED_OS" ] && [ "$arch" = "$SELECTED_ARCH" ]; then
                                if [ "$SELECTED_COMP" = "默认" ]; then
                                    if echo "$fname" | grep -qE -- '-(compatible|go[0-9]+)-'; then continue; fi
                                elif [ "$SELECTED_COMP" != "默认" ]; then
                                    if ! echo "$fname" | grep -q -- "-$SELECTED_COMP-"; then continue; fi
                                fi
                                echo -e "${MENU_OPTION_COLOR}  $IDX. $fname${NC}"
                                eval "PKG_$IDX=\"$line\""
                                IDX=$((IDX+1))
                            fi
                        done < "$TMP_LIST"
                        [ $IDX -eq 1 ] && print_error "无可用包，返回上一级。" && continue
                        echo -e "${YELLOW}  0. 返回上一级${NC}"
                        print_divider
                        echo -ne "${MENU_CHOICE_COLOR}请输入包序号（0返回）：${NC}"
                        read -r PKG_IDX
                        [ "$PKG_IDX" = "0" ] && break
                        eval "DOWNLOAD_URL=\$PKG_$PKG_IDX"
                        [ -z "$DOWNLOAD_URL" ] && print_error "无效选择，请重试。" && continue
                        
                        # 下载和安装
                        download_and_install "$DOWNLOAD_URL"
                        exit 0
                    done
                done
            done
            ;;
            
        2)
            # 仅检测系统和架构，不下载
            print_divider
            echo -e "${MENU_TITLE_COLOR}🔍 正在检测系统和架构...${NC}"
            SYS_INFO=$(detect_system_info)
            DETECTED_OS=$(echo "$SYS_INFO" | cut -d' ' -f1)
            DETECTED_ARCH=$(echo "$SYS_INFO" | cut -d' ' -f2)
            
            print_divider
            echo -e "${GREEN}检测到系统: ${YELLOW}$DETECTED_OS${NC}"
            echo -e "${GREEN}检测到架构: ${YELLOW}$DETECTED_ARCH${NC}"
            print_divider
            echo -e "${MENU_OPTION_COLOR}系统架构信息仅供参考，请使用「手动分级选择」进行下载${NC}"
            print_divider
            
            echo -ne "${MENU_CHOICE_COLOR}按任意键返回主菜单...${NC}"
            read -r
            # 在在线运行模式下，返回主菜单不适用，直接退出脚本
            echo -e "${YELLOW}请重新运行脚本以返回主菜单${NC}"
            exit 0
            ;;
            
        3)
            # 设置GitHub Token
            print_divider
            echo -e "${MENU_TITLE_COLOR}⚙ GitHub Token 设置${NC}"
            echo -e "Token可以解决GitHub API限流问题，获取Token方法："
            echo -e "1. 访问 https://github.com/settings/tokens"
            echo -e "2. 点击 'Generate new token'"
            echo -e "3. 只需勾选 'public_repo' 权限即可"
            echo -e "4. 点击生成并复制Token"
            print_divider
            
            echo -ne "${MENU_CHOICE_COLOR}请输入GitHub Token (留空清除现有Token): ${NC}"
            read -r github_token
            
            if [ -z "$github_token" ]; then
                if [ -f "$TOKEN_FILE" ]; then
                    rm -f "$TOKEN_FILE"
                    print_success "已清除GitHub Token"
                else
                    print_warning "未设置Token"
                fi
            else
                echo "$github_token" > "$TOKEN_FILE"
                chmod 600 "$TOKEN_FILE"
                print_success "Token已保存"
            fi
            
            echo -e "${YELLOW}设置已完成，请重新运行脚本${NC}"
            exit 0
            ;;
            
        4)
            echo -e "${YELLOW}👋 已选择退出，欢迎下次使用！${NC}"
            exit 0
            ;;
            
        *)
            echo -e "${YELLOW}未选择任何操作，脚本结束。${NC}"
            exit 0
            ;;
    esac
}

# 执行主函数
main