#!/data/data/com.termux/files/usr/bin/bash

# tmux status bar left - OneDark theme
# Outputs tmux-formatted status line for left side

# Colors (OneDark)
black="#1e222a"
green="#7eca9c"
white="#abb2bf"
grey="#282c34"
blue="#7aa2f7"
red="#d47d85"
darkblue="#668ee3"
yellow="#e5c07b"


git_added_icon=""
git_modified_icon=""
git_updated_icon=""
git_deleted_icon=""
git_repo_icon="'"
git_diff_icon=""
git_no_repo_icon="'"
tmux_icon=""


# Tmux pill
print_tmux_icon() {
    printf "#[fg=%s,bg=%s] %s #[default]" "$black" "$green" "$tmux_icon"
}

# Get current pane directory
get_pane_dir() {
    nextone="false"
    for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}"); do
        if [ "$nextone" == "true" ]; then
            echo "$i"
            return
        fi
        if [ "$i" == "1" ]; then
            nextone="true"
        fi
    done
}

# Check if directory is a git repo
check_for_git_dir() {
    if [ "$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null)" != "" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# Check for uncommitted changes
check_for_changes() {
    if [ "$(check_for_git_dir)" == "true" ]; then
        if [ "$(git -C "$path" status -s 2>/dev/null)" != "" ]; then
            echo "true"
        else
            echo "false"
        fi
    else
        echo "false"
    fi
}

# Get current branch name (truncated to 20 chars)
get_branch() {
    if [ "$(check_for_git_dir)" == "true" ]; then
        printf "%.20s" "$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null)"
    fi
}

# Count changes by type
get_changes() {
    declare -i added=0
    declare -i modified=0
    declare -i updated=0
    declare -i deleted=0

    for i in $(git -C "$path" status -s 2>/dev/null); do
        case $i in
        'A') added+=1 ;;
        'M') modified+=1 ;;
        'U') updated+=1 ;;
        'D') deleted+=1 ;;
        esac
    done

    output=""
    [ $added -gt 0 ] && output+="${added} $git_added_icon "
    [ $modified -gt 0 ] && output+="${modified} $git_modified_icon "
    [ $updated -gt 0 ] && output+="${updated} $git_updated_icon "
    [ $deleted -gt 0 ] && output+="${deleted} $git_deleted_icon "

    echo "$output"
}

# Git status with tmux formatting
git_status() {
    path=$(get_pane_dir)

    if [ "$(check_for_git_dir)" == "true" ]; then
        branch=$(get_branch)

        if [ "$(check_for_changes)" == "true" ]; then
            changes=$(get_changes)
            # Has changes - show diff icon, changes, and branch in yellow/red
            printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %s%s " "$black" "$yellow" "$git_diff_icon" "$white" "$grey" "$changes" "$branch"
        else
            # Clean repo - show repo icon and branch in green
            printf "#[fg=%s,bg=%s] %s #[fg=%s,bg=%s] %s " "$black" "$green" "$git_repo_icon" "$white" "$grey" "$branch"
        fi
    else
        # Not a git repo
        printf "#[fg=%s,bg=%s] %s #[default]" "$white" "$grey" "$git_no_repo_icon"
    fi
}

# Build the status line
main() {
    printf "%s%s#[default]" "$(print_tmux_icon)" "$(git_status)"
}

main
