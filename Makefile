IMG=jsalatiel/wsbb-podman:latest
CONTAINER_NAME=wsbb
DOCKERCMD=sudo podman


USER_UID = $(shell id -u $(USER))
USER_GID = $(shell id -g $(USER))
ifeq ($(shell uname),Darwin)
	USER_GID = $(shell id -u $(USER))
endif

build:
	$(DOCKERCMD) build -t ${IMG} .

start:
	$(DOCKERCMD) run -d  --rm -it --name ${CONTAINER_NAME} \
		--cap-add CAP_AUDIT_WRITE  --cap-add  CAP_SYS_PTRACE  \
		-e USER_UID=$(USER_UID) \
		-e USER_GID=$(USER_GID) \
		-v "$(HOME)/.Xauthority:/home/user/.Xauthority:ro" \
		-v "/tmp/.X11-unix:/tmp/.X11-unix:ro" \
		-v "/etc/machine-id:/etc/machine-id:ro" \
		$(IMG) seg.bb.com.br
logs:
	$(DOCKERCMD) logs -f ${CONTAINER_NAME}

shell:
	$(DOCKERCMD) exec -it ${CONTAINER_NAME} bash

stop:
	-$(DOCKERCMD) kill ${CONTAINER_NAME}

remove:
	-$(DOCKERCMD) image rm ${CONTAINER_NAME}

