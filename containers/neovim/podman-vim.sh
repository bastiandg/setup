#/bin/bash
CONTAINER_NAME="nvim-container"
CONTAINER_IMAGE_NAME="nvim:latest"
nvim_instance=$(podman container ls --filter name="$CONTAINER_NAME" --format "{{.ID}}")
if [[ -z "$nvim_instance" ]]; then
    nvim_instance=$(podman container run -d --rm -it \
        --userns=keep-id \
        -v /home/bastian:/home/bastian:rw \
        -h "$HOSTNAME" \
        -v "/tmp/.X11-unix:/tmp/.X11-unix" \
        -e "DISPLAY=${DISPLAY}" \
        -v "$HOME/.Xauthority:/home/$USER/.Xauthority" \
        --network host \
        --name "$CONTAINER_NAME" \
        "$CONTAINER_IMAGE_NAME")
fi

podman exec --env "WORKDIR=$(pwd)" -it "$nvim_instance" vim "$@"
