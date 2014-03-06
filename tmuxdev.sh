tmux new-session -d -s dev
tmux split-window -t dev:0 -v -d -p 80
tmux attach-session -t dev
