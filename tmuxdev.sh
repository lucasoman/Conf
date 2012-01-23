tmux new-session -d -s dev
tmux split-window -t dev:0 -h -d -p 20
tmux attach-session -t dev
