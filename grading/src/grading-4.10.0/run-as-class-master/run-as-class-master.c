#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <strings.h>
#include <string.h>

#include <sys/stat.h>
#include <limits.h>

/* Constants that must be supplied at compilation time. */

/* The search path for directories containing executables that may be
 * run with my effective UID.  Directories in this colon-separated
 * list of absolute directory names are considered in the order
 * listed. */
static const char execDirectoryPath[] = EXEC_DIRS "\000\000\000";

/* The constant part of the environment under which to run the 
   privileged program. */
static char* execEnv[] = { ENVIRON, NULL };

#ifdef PRIVATE
/* Names of environment variables to copy from the current
 * environment. */
static char* copyEnvs[] = { "HOME", "PWD", "MASTERDIR", "GRADINGDIR" };
#else
static char* copyEnvs[] = { "HOME", "PWD", NULL };
#endif

void fail () __attribute__ ((noreturn));
void fail ()
{
  fprintf (stderr, "Failed to run setuid program.\n");
  abort ();
}

int main (int argc, char* argv[])
{
  char* program;
  char* base;
  struct stat stats;
  char** envp1 = (char**) malloc (sizeof (execEnv) + sizeof (copyEnvs));
  int i, j, d;

  if (argc < 2 || strlen (argv[1]) > PATH_MAX)
    exit (1);

  program = 
    (char*) malloc (strlen (execDirectoryPath) + strlen (argv[1]) + 3);

  d = 0;
  while (execDirectoryPath[d] != '\0') {
    const char* delim = strchr (execDirectoryPath + d, ':');
    int dlen;
    if (delim == NULL)
      dlen = strlen (execDirectoryPath + d);
    else
      dlen = delim - execDirectoryPath - d;
    strncpy (program, execDirectoryPath + d, dlen);
    program[dlen] = '\0';
    d += dlen + 1;
    
    /* Simple sanity check: Check that directory containing executables
     * is an existing directory, specified with an absolute path name,
     * not writable by group or others, and not a symbolic link. */
    if (program[0] != '/'
	|| lstat (program, &stats) != 0
	|| (stats.st_mode & (S_IFLNK|S_IWGRP|S_IWOTH)) != 0
	|| (stats.st_mode & S_IFDIR) == 0)
      continue;
  
    base = strrchr (argv[1], '/');
    if (base == NULL)
      base = argv[1];
    else
      base += 1;
    if (strcmp (base, "..") == 0)
      fail ();
    if (program[dlen-1] != '/')
      strcat (program, "/");
    strcat (program, base);

    /* Check that program to be executed exists, and is not writable by
     * group or others. */
    if (stat (program, &stats) != 0
	|| (stats.st_mode & (S_IWGRP|S_IWOTH)) != 0)
      continue;

    /* Set up argument list from arguments passed, including terminal
     * NULL */
    argv[0] = program;
    for (i = 2; i <= argc; i += 1)
      argv[i-1] = argv[i];

    /* Copy selected items from the current environment. */
    j = 0;
    for (i = 0; copyEnvs[i] != NULL; i += 1) {
      const char* val = getenv (copyEnvs[i]);
      if (val != NULL) {
	envp1[j] = (char*) malloc (strlen (copyEnvs[i]) + strlen (val) + 2);
	strcpy (envp1[j], copyEnvs[i]);
	strcat (envp1[j], "=");
	strcat (envp1[j], val);
	j += 1;
      }
    }
    /* Copy the rest of the environment from execEnv. */
    memcpy (envp1+j, execEnv, sizeof (execEnv));

    execve (program, argv, envp1);
    perror ("Execve failed");
    abort ();
  }
  fail ();

}

  
