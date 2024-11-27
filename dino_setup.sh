SERVER_IP=$(hostname -I | awk '{print $1}')


# Final message
echo "Setup complete! Dino and Dinodisplay should be live:"
echo "- $DINO_DOMAIN"
echo "- $DINODISPLAY_DOMAIN"
echo "Admin panel available at $SERVER_IP:5000"
