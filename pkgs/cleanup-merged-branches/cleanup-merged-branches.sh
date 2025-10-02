#!/bin/bash

set -euo pipefail

readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

readonly MAIN_BRANCH="${MAIN_BRANCH:-main}"
readonly PR_LIMIT="${PR_LIMIT:-1000}"

log_info() {
	echo -e "${GREEN}$*${NC}"
}

log_warn() {
	echo -e "${YELLOW}$*${NC}"
}

log_error() {
	echo -e "${RED}$*${NC}"
}

log_success() {
	echo -e "${GREEN}✓${NC} $*"
}

log_failure() {
	echo -e "${RED}✗${NC} $*"
}

check_requirements() {
	if ! command -v gh &>/dev/null; then
		log_error "Error: GitHub CLI (gh) is not installed"
		exit 1
	fi
}

fetch_remote() {
	log_info "Fetching latest changes from remote..."
	git fetch --prune
}

get_merged_pr_branches() {
	log_info "Fetching list of merged PRs from GitHub..."
	gh pr list --state merged --limit "$PR_LIMIT" --json headRefName --jq '.[].headRefName' | sort
}

get_local_branches() {
	git branch | sed 's/^\*\? *//g' | grep -v "^${MAIN_BRANCH}$" | sort
}

find_branches_to_delete() {
	local merged_pr_branches="$1"
	local local_branches="$2"
	comm -12 <(echo "$local_branches") <(echo "$merged_pr_branches")
}

confirm_deletion() {
	local prompt="$1"
	read -p "$prompt (y/N) " -n 1 -r </dev/tty
	echo
	[[ $REPLY =~ ^[Yy]$ ]]
}

delete_merged_pr_branches() {
	local branches="$1"
	local deleted_count=0

	while IFS= read -r branch; do
		if git branch -D "$branch" >/dev/null 2>&1; then
			log_success "Deleted: $branch"
			deleted_count=$((deleted_count + 1))
		else
			log_failure "Failed to delete: $branch"
		fi
	done <<<"$branches"

	echo ""
	log_info "Deleted $deleted_count branches"
}

process_merged_pr_branches() {
	local merged_pr_branches
	local local_branches
	local branches_to_delete

	merged_pr_branches=$(get_merged_pr_branches)
	local_branches=$(get_local_branches)
	branches_to_delete=$(find_branches_to_delete "$merged_pr_branches" "$local_branches")

	if [ -z "$branches_to_delete" ]; then
		log_warn "No branches with merged PRs found to delete"
		return
	fi

	local count
	count=$(echo "$branches_to_delete" | wc -l)
	log_warn "Found ${NC}${count}${YELLOW} branches with merged PRs:${NC}"
	echo "$branches_to_delete"
	echo ""

	if confirm_deletion "Do you want to delete these branches?"; then
		delete_merged_pr_branches "$branches_to_delete"
	else
		log_warn "Cancelled"
		exit 0
	fi
}

get_branches_merged_into_main() {
	git branch --merged "$MAIN_BRANCH" | grep -v '^\*' | grep -v "^${MAIN_BRANCH}$" || true
}

process_branches_merged_into_main() {
	local merged_into_main

	log_info "Checking for branches merged into ${MAIN_BRANCH}..."
	merged_into_main=$(get_branches_merged_into_main)

	if [ -z "$merged_into_main" ]; then
		log_warn "No additional branches merged into ${MAIN_BRANCH}"
		return
	fi

	log_warn "Found branches merged into ${MAIN_BRANCH}:"
	echo "$merged_into_main"
	echo ""

	if confirm_deletion "Do you want to delete these branches?"; then
		echo "$merged_into_main" | xargs -r git branch -d
		log_success "Deleted branches merged into ${MAIN_BRANCH}"
	else
		log_warn "Cancelled"
	fi
}

show_summary() {
	echo ""
	log_info "Cleanup complete!"
	echo "Remaining branches: $(git branch | wc -l)"
}

main() {
	log_warn "Git Branch Cleanup Script"
	echo "This script will delete local branches that have merged PRs"
	echo ""

	check_requirements
	fetch_remote
	process_merged_pr_branches

	echo ""
	process_branches_merged_into_main
	show_summary
}

main "$@"
