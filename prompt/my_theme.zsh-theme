#!/bin/sh
## zshprompt for ctafconf in /ctaf/conf/ctafconf/zsh
##
## Made by GESTES Cedric
## Login   <ctaf42@gmail.com>
##
## Started on  Fri Feb 11 01:37:23 2005 GESTES Cedric
## Last update Thu May 27 18:03:33 2010 Cedric GESTES
##
##CTAFCONF

typeset -gA zgit_info
zgit_info=()

zgit_chpwd_hook() {
  zgit_info_update
}

zgit_preexec_hook() {
  if [[ $2 == git\ * ]] || [[ $2 == *\ git\ * ]]; then
    zgit_precmd_do_update=1
  fi
}

zgit_precmd_hook() {
  if [ $zgit_precmd_do_update ]; then
    unset zgit_precmd_do_update
    zgit_info_update
  fi
}

zgit_info_update() {
  zgit_info=()

  local gitdir=$(git rev-parse --git-dir 2>/dev/null)
  if [ $? -ne 0 ] || [ -z "$gitdir" ]; then
    return
  fi

  zgit_info[dir]=$gitdir
  zgit_info[bare]=$(git rev-parse --is-bare-repository)
  zgit_info[inwork]=$(git rev-parse --is-inside-work-tree)
}

zgit_isgit() {
  if [ -z "$zgit_info[dir]" ]; then
    return 1
  else
    return 0
  fi
}

zgit_inworktree() {
  zgit_isgit || return
  if [ "$zgit_info[inwork]" = "true" ]; then
    return 0
  else
    return 1
  fi
}

zgit_isbare() {
  zgit_isgit || return
  if [ "$zgit_info[bare]" = "true" ]; then
    return 0
  else
    return 1
  fi
}

zgit_head() {
  zgit_isgit || return 1

  if [ -z "$zgit_info[head]" ]; then
    local name=''
    name=$(git symbolic-ref -q HEAD)
    if [ $? -eq 0 ]; then
      if [[ $name == refs/(heads|tags)/* ]]; then
        name=${name#refs/(heads|tags)/}
      fi
    else
      name=$(git name-rev --name-only --no-undefined --always HEAD)
      if [ $? -ne 0 ]; then
        return 1
      elif [[ $name == remotes/* ]]; then
        name=${name#remotes/}
      fi
    fi
    zgit_info[head]=$name
  fi

  echo $zgit_info[head]
}

zgit_branch() {
  zgit_isgit || return 1
  zgit_isbare && return 1

  if [ -z "$zgit_info[branch]" ]; then
    local branch=$(git symbolic-ref HEAD 2>/dev/null)
    if [ $? -eq 0 ]; then
      branch=${branch##*/}
    else
      branch=$(git name-rev --name-only --always HEAD)
    fi
    zgit_info[branch]=$branch
  fi

  echo $zgit_info[branch]
  return 0
}

zgit_tracking_remote() {
  zgit_isgit || return 1
  zgit_isbare && return 1

  local branch
  if [ -n "$1" ]; then
    branch=$1
  elif [ -z "$zgit_info[branch]" ]; then
    branch=$(zgit_branch)
    [ $? -ne 0 ] && return 1
  else
    branch=$zgit_info[branch]
  fi

  local k="tracking_$branch"
  local remote
  if [ -z "$zgit_info[$k]" ]; then
    remote=$(git config branch.$branch.remote)
    zgit_info[$k]=$remote
  fi

  echo $zgit_info[$k]
  return 0
}

zgit_tracking_merge() {
  zgit_isgit || return 1
  zgit_isbare && return 1

  local branch
  if [ -z "$zgit_info[branch]" ]; then
    branch=$(zgit_branch)
    [ $? -ne 0 ] && return 1
  else
    branch=$zgit_info[branch]
  fi

  local remote=$(zgit_tracking_remote $branch)
  [ $? -ne 0 ] && return 1
  if [ -n "$remote" ]; then # tracking branch
    local merge=$(git config branch.$branch.merge)
    if [ $remote != "." ]; then
      merge=$remote/$(basename $merge)
    fi
    echo $merge
    return 0
  else
    return 1
  fi
}

zgit_isindexclean() {
  zgit_isgit || return 1
  if git diff --quiet --cached 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

zgit_isworktreeclean() {
  zgit_isgit || return 1
  if git diff --quiet 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

zgit_hasuntracked() {
  zgit_isgit || return 1
  local -a flist
  flist=($(git ls-files --others --exclude-standard))
  if [ $#flist -gt 0 ]; then
    return 0
  else
    return 1
  fi
}

zgit_hasunmerged() {
  zgit_isgit || return 1
  local -a flist
  flist=($(git ls-files -u))
  if [ $#flist -gt 0 ]; then
    return 0
  else
    return 1
  fi
}

zgit_svnhead() {
  zgit_isgit || return 1

  local commit=$1
  if [ -z "$commit" ]; then
    commit='HEAD'
  fi

  git show --raw $commit | \
    grep git-svn-id | \
      sed -re 's/^\s*git-svn-id: .*@([0-9]+).*$/\1/'
}
zgit_svnbranch() {
  zgit_isgit || return 1

  local commit=$1
  if [ -z "$commit" ]; then
    commit='HEAD'
  fi

  git show --raw $commit | \
    grep git-svn-id | \
    sed -re 's!^\s*git-svn-id: .*/(.*)@.*$!\1!'
}

zgit_rebaseinfo() {
  zgit_isgit || return 1
  if [ -d $zgit_info[dir]/rebase-merge ]; then
    dotest=$zgit_info[dir]/rebase-merge
  elif [ -d $zgit_info[dir]/.dotest-merge ]; then
    dotest=$zgit_info[dir]/.dotest-merge
  elif [ -d .dotest ]; then
    dotest=.dotest
  else
    return 1
  fi

  zgit_info[dotest]=$dotest

  zgit_info[rb_onto]=$(cat "$dotest/onto")
  zgit_info[rb_upstream]=$(cat "$dotest/upstream")
  if [ -f "$dotest/orig-head" ]; then
    zgit_info[rb_head]=$(cat "$dotest/orig-head")
  elif [ -f "$dotest/head" ]; then
    zgit_info[rb_head]=$(cat "$dotest/head")
  fi
  zgit_info[rb_head_name]=$(cat "$dotest/head-name")

  return 0
}

zgitinit() {
  typeset -ga chpwd_functions
  typeset -ga preexec_functions
  typeset -ga precmd_functions
  chpwd_functions+='zgit_chpwd_hook'
  preexec_functions+='zgit_preexec_hook'
  precmd_functions+='zgit_precmd_hook'
}

zgitinit
zgit_info_update

autoload -Uz colors   && colors
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

####################################
# COLORS
####################################
bright="\033[m1;"
dull="\033[m0;"
for color in BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg_no_bold[${(L)color}]%}'
  eval PR_BG_$color='%{$bg[${(L)color}]%}'
  eval PR_LIGHT_$color='%{$fg_bold[${(L)color}]%}'
  (( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

#customise this two variable to change foreground/background
#left empty for automatic default
PR_BG_PROMPT=""
PR_FG_PROMPT="${PR_NO_COLOUR}"

####################################
# VCS_INFO
####################################
#may be slow
zstyle ':vcs_info:*:ctaf:*' check-for-changes false
#may be slow
zstyle ':vcs_info:*:ctaf:*' get-revision      false
zstyle ':vcs_info:*:ctaf:*' use-simple        false
zstyle ':vcs_info:*:ctaf:*' max-exports       2

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
#default format for standard vcs
ACTION="[${PR_LIGHT_RED}%a${PR_FG_PROMPT}]"
FORMAT="%s on ${PR_MAGENTA}%b${PR_FG_PROMPT}"
FORMAT_ACTION="$FORMAT $ACTION"
zstyle ':vcs_info:*:ctaf:*' formats             "$FORMAT" "%s"
zstyle ':vcs_info:*:ctaf:*' actionformats       "$FORMAT_ACTION" "%s"
zstyle ':vcs_info:*:ctaf:*' branchformat        "${PR_MAGENTA}%b${PR_FG_PROMPT}:${PR_LIGHT_RED}%r${PR_NO_COLOUR}"

prompt_ctaf_git_tracking_branch()
{
  t=$(zgit_tracking_merge)
  if ! [ "$t" = "" ] ; then
    echo " tracking${PR_LIGHT_MAGENTA} ${t}${PR_FG_PROMPT}"
  fi
}

#format vcs information, append information to vcs_info that is a little poor
#this function is called each time a prompt need to be display
#this function set the psvar with changing information
prompt_ctaf_precmd() {
  setopt noxtrace noksharrays localoptions
  #if the function is not found, fail silently (degraded mode)
  vcs_info 'ctaf' 2>/dev/null
  psvar=()
  case "$vcs_info_msg_1_" in
    git)
      GIT_FORMAT="$vcs_info_msg_0_ (${PR_LIGHT_YELLOW}$(git describe --always --tags 2>/dev/null)${PR_FG_PROMPT})$(prompt_ctaf_git_tracking_branch 2>/dev/null)"
      psvar[1]="[$GIT_FORMAT]"
      ;;
    git-svn)
      GITSVN_FORMAT="$vcs_info_msg_0_ (${PR_LIGHT_YELLOW}$(git describe --always --tags) ${PR_MAGENTA}$(zgit_svnbranch)${PR_FG_PROMPT}:${PR_LIGHT_RED}$(zgit_svnhead)${PR_FG_PROMPT})$(prompt_ctaf_git_tracking_branch)"
      psvar[1]="[$GITSVN_FORMAT]"
      ;;
    "")
      #no vcs info => dont do anything
      ;;
    *)
      psvar[1]="[$vcs_info_msg_0_]"
      ;;
  esac
  if [ "$psvar[1]" != "" ] ; then
    psvar[1]="${PR_BG_PROMPT}${PR_FG_PROMPT}$psvar[1]${PR_NO_COLOUR}
"
  fi
  psvar[2]=""
  if ! [ -z $CTAFCONF_ENV ] ; then
    psvar[2]="${PR_NO_COLOUR}/${PR_LIGHT_RED}${CTAFCONF_ENV}"
  fi
  if ! [ -z $SCHROOT_COMMAND ] ; then
    psvar[2]="${PR_LIGHT_YELLOW}:SCHROOT${PR_NO_COLOUR}$psvar[2]"
  fi
}



prompt_ctaf_setup () {
  add-zsh-hook precmd prompt_ctaf_precmd 2>/dev/null
  BASE_PROMPT="${PR_BG_PROMPT}${PR_LIGHT_MAGENTA}%(!.%SROOT%s.${PR_FG_PROMPT}%n${PR_LIGHT_YELLOW})\
@${PR_LIGHT_GREEN}%m\$psvar[2]${PR_LIGHT_MAGENTA} \
[%(?.${PR_FG_PROMPT}$?.${PR_LIGHT_RED}% err %?)${PR_LIGHT_MAGENTA}] \
[${PR_LIGHT_BLUE}%~${PR_LIGHT_MAGENTA}]${PR_NO_COLOUR}
${PR_BG_PROMPT}${PR_FG_PROMPT}z${PR_LIGHT_GREEN}%(!.#.$)${PR_NO_COLOUR} "

  PROMPT="\$psvar[1]${BASE_PROMPT}"
  RPROMPT="[${PR_BG_PROMPT}${PR_LIGHT_CYAN}%D ${PR_LIGHT_GREEN}%T${PR_NO_COLOUR}]"

  PS2=''
}

prompt_ctaf_setup "$@"
