// Allow a non-root user to run an arbitrary command in a network namespace,
// useful for a wireguard namespace.

// compile with: gcc -s -o wgx wgx.c
// then run: sudo chmod u+s wgx

// example usage: wgx ip netns identify

#define NAME_OF_NETWORK_NAMESPACE  "wg0"
#define PATH_TO_NAMESPACE  "/run/netns/"  NAME_OF_NETWORK_NAMESPACE

#define _GNU_SOURCE

#include <fcntl.h>
#include <sched.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

void
die(int status, char *message) {
	printf("%s\n", message);
	exit(status);
}

int
main(int argc, char **argv) {
	if(!(geteuid() == 0))
		die(3,
		    "This program needs to be run as effective root."
		    "Is the binary owned by root and is the setuid bit set ?");

	int fd = open(PATH_TO_NAMESPACE, O_RDONLY);
	if(fd == -1)
		die(2,
		    "Namespace " NAME_OF_NETWORK_NAMESPACE
		    " does not exist.");
	if(!(setns(fd, CLONE_NEWNET) == 0))
		die(-1, "Couldn't set namespace.");
	if(!(close(fd) == 0))
		die(-1, "Couldn't close ns fd");

	if(!(setgid(getgid()) == 0 && setuid(getuid()) == 0))
		die(-1, "Couldn't drop effective root or root group");

	if(argc > 1)
		execvpe(argv[1], argv + 1, environ);

    die(1, "A command is required.");
}
