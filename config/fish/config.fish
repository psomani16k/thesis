if status is-interactive
    # Commands to run in interactive sessions can go here
end

# aliases
alias rmrf="rm -rf"
alias qq="exit"
alias obsidian="flatpak run md.obsidian.Obsidian"
alias clear="echo 'Please use CTRL+L'"

# paths
set PATH "$PATH:/home/parth/flutterSDK/bin"
set PATH "$PATH:/opt/android-studio/bin"
set PATH "$PATH:/home/parth/flutter/bin"
set PATH "$PATH:/home/parth/bin"

# starship
starship init fish | source

# cargo bins
source ~/.cargo/env.fish

source ~/.ssh/api_keys.fish

# android build caching
set -x USE_CCACHE 1
set -x CCACHE_EXEC "/usr/bin/ccache"

# using a superior editor
set -x EDITOR "/usr/bin/nvim"

# go and bazel related stuff
set -x USE_BAZEL_VERSION 6.4.0
set -x JAVA_HOME /usr/lib/jvm/jre-21-openjdk

# The following snippet is meant to be used like this in your fish configuration:
# if status is-interactive
#     # Maybe set ZELLIJ_AUTO_ATTACH / ZELLIJ_AUTO_EXIT
#     eval (zellij setup --generate-auto-start fish | string collect)
# end
if not set -q ZELLIJ                                                                                                                                                           
    if test "$ZELLIJ_AUTO_ATTACH" = "true"                                                                                                                                     
        zellij attach -c                                                                                                                                                       
    else                                                                                                                                                                       
        zellij                                                                                                                                                                 
    end                                                                                                                                                                        
                                                                                                                                                                               
    if test "$ZELLIJ_AUTO_EXIT" = "true"                                                                                                                                       
        kill $fish_pid                                                                                                                                                         
    end                                                                                                                                                                        
end

set -x GITLAB_HOME /srv/gitlab
