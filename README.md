```bash
echo "deb [trusted=yes] https://github.com/serhiivysotskyi/test_ros2/raw/jammy-iron-amd64/ ./" | sudo tee /etc/apt/sources.list.d/serhiivysotskyi_test_ros2.list
echo "yaml https://github.com/serhiivysotskyi/test_ros2/raw/jammy-iron-amd64/local.yaml iron" | sudo tee /etc/ros/rosdep/sources.list.d/1-serhiivysotskyi_test_ros2.list
```
