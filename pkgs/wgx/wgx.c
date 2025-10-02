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

int
die_f (int line_number)
{
  printf("Error on line %d\n", line_number);
  exit(3);
  return -1;
}


#define die (die_f(__LINE__))


int
main (int argc, char **argv)
{
  getuid() == 0 && die; // must not be real root
  getgid() == 0 && die; // must not be real root group
  geteuid() == 0 || die; // must be effective root

  int fd = open(PATH_TO_NAMESPACE, O_RDONLY);
  if (fd == -1) {
    printf("Namespace " NAME_OF_NETWORK_NAMESPACE " does not exist. Exiting.\n");
    exit(2);
  };
  setns(fd, CLONE_NEWNET) == 0 || die;
  close(fd) == 0 || die;

  setgid(getgid ()) == 0 || die; // drop effective root group           
  setuid(getuid ()) == 0 || die; // grop effecitve root                 

  getuid() == 0 && die; // must not be real root                          
  getgid() == 0 && die; // must not be real root group                    
  geteuid() == 0 && die; // must not be effective root                     
  getegid() == 0 && die; // must not be effecitve root group               

  if (argc > 1)
    {
      execvpe(argv[1], argv + 1, environ);
    }

  printf("A command is needed.");
  return 1;
}
