#!/bin/bash

# --- START SERVER: ERIKA ---
# Creating a session named 'erika'
tmux new-session -d -s erika
tmux send-keys -t erika "cd '/home/alex/Documents/MinecraftServers/Erika' && java -Xms1G -Xmx2G -jar server.jar nogui" C-m

# --- START SERVER: MAIN MODDED FOREVER ---
# Creating a session named 'forever'
tmux new-session -d -s forever
tmux send-keys -t forever "cd '/home/alex/Documents/MinecraftServers/Main modded forever' && java -Xms3G -Xmx4G -jar fabric-server-mc.26.1.2-loader.0.19.2-launcher.1.1.1.jar nogui" C-m

echo "------------------------------------------------------"
echo "Minecraft Servers are launching in separate sessions!"
echo "------------------------------------------------------"
echo "To see Erika:    tmux a -t erika"
echo "To see Forever:  tmux a -t forever"
echo ""
echo "To exit a view:  Press Ctrl+B, then D"
echo "To see all running: tmux ls"
echo "------------------------------------------------------"
