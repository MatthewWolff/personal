#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h> // defines output stream file numbers
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <ctype.h>

#define IN_SIZE 128
#define TRUE 1
#define FALSE 0

int history_num = 1;

void input_prompt() {
	char prompt[30];
	sprintf(prompt, "mysh (%d)> ", history_num++);
	write(STDOUT_FILENO, prompt, strlen(prompt));
	fflush(stdout);
}

void print_error() {
	char error_message[30] = "An error has occurred\n";
	write(STDERR_FILENO, error_message, strlen(error_message));
	fflush(stderr);
}

/**
 * retrieve input from stdin for dissection.
 */
char* get_input() {
	char *str;
	str = malloc(sizeof(void)); //size is start size
	if(str == NULL) {
		return NULL;
	}

	int input_size = 1; // initial
	int character, size = 0;
	while(!(EOF == (character = fgetc(stdin)) || character == '\n')) {
		str[size++] = character;
		if(size==input_size) {
			str = realloc(str, sizeof(void)*(++input_size));
			if(str == NULL) 
				return NULL;
		}
	}
	str[size]='\0'; //set terminating char
	str = realloc(str, sizeof(void)*++size);
	return str;
}


/**
 * Dissect arguments and return count after putting words into array
 */
int split_line(char* input, char* words[]) {
	int word_count = 0;
	char *token = strtok(input, " \t"); // dual char
	while(token != NULL) {
		words[word_count++] = strdup(token);
		token = strtok(NULL, " \t");
	}
	words[word_count] = NULL; // set null char

	free(input); // last use, free it
	free(token);

	++word_count;
	return --word_count; // i hate this program
}

/**
 * counts the number of words in a line without murdering it
 */
int word_count(char* line) {
	int token_counter = 0;
	char *ptr = strdup(line);
	ptr = strtok(ptr, " \t"); // dual char
	while(ptr != NULL) {
		++token_counter;
		++ptr;
		ptr = strtok(ptr, " \t");
	}
	return ++token_counter;
}

/**
 * internal CD command
 */
void run_cd(char* path[]) {
	if(path[1] == NULL) {
		chdir(getenv("HOME"));
	} else if(-1 == chdir(path[1])) {
		print_error();
	}
}


/**
 * internal PWD command
 */
void run_pwd(char* args[]) {
	if(args[1] == NULL) { // no secondary args
		char path[1000];
		getcwd(path, 1000);
		printf("%s\n", path);
	} else print_error();
}

/**
 * gimme dat pipe
 * http://tldp.org/LDP/lpg/node11.html
 */
void run_pipe(int* fd, char* command1[], char* command2[]) {
	int pipe1 = fork();
	if(pipe1 == 0) { // child
		dup2(fd[0], 0);
		close(fd[1]);
		execvp(command2[0], command2);
		print_error();
	} else {
		int pipe2 = fork();
		if(pipe2 == 0) { // another child
			dup2(fd[1], STDOUT_FILENO);
			close(fd[0]);
			execvp(command1[0], command1);
			print_error();
		} else { //parent
			int status;

			close(fd[0]); // parent sends data to child
			close(fd[1]);

			waitpid(pipe1, &status, WUNTRACED);
			waitpid(pipe2, &status, WUNTRACED);

			while(!(WIFEXITED(status) || WIFSIGNALED(status))) {
				waitpid(pipe1, &status, WUNTRACED);
				waitpid(pipe2, &status, WUNTRACED);
			}
			/*"The status of any child processes specified by pid that are
			stopped, and whose status has not yet been reported since they
			stopped, shall also be reported to the requesting process."*/
		}
	}
}

int main(int argc, char *argv[]) {

	if(argc != 1) {
		print_error();
		exit(1);
	}

	while(TRUE) {
		input_prompt();
		char *input = get_input(); // get dynamically sized input

		if(strlen(input) >= IN_SIZE)
		{
			print_error();
			continue;
		}

		// parse input string
		int count = word_count(input);
		char *words[count];
		int num_words = split_line(input, words);

		if(words[0] == NULL) { //empty line 
			history_num--;
			continue;
		}

		// check for piping and background commands
		int is_pipeline = FALSE, pipe_index = 0;
		int is_bg = FALSE, bg_index = 0;
		while(words[pipe_index] != NULL) {
			if(strcmp(words[pipe_index], "|") == 0) {
				is_pipeline = TRUE;
				break;
			}
			else if(strcmp(words[bg_index], "&") == 0) {
				if(bg_index < (num_words-1)) {
					print_error();
					continue;
				}
				is_bg = TRUE;
				words[bg_index] = NULL; // remove from input
				break;
			} else {
				++pipe_index;
				++bg_index;
			}
		}

		// exit command (ALL, not just child threads.)
		if(!strcmp(words[0], "exit")) {
			kill(0, SIGINT); // haha or just kill me instead
		}

		// forking
		int process_id = fork();
		if (process_id > 0) {
			if(!is_bg) wait(NULL);

		} else if(process_id == 0) {
			char* outfile="";
			char* infile="";
			int index_first_op = -1;
			int is_redirection_error = FALSE;

			if(strcmp(words[0], ">") == FALSE || strcmp(words[0], "<") == FALSE) {
				continue;
			}

			int index = 0;++index;
			while(words[index]) {
				//output redirection
				if(strcmp(words[index], ">") == 0) {
					if(words[index + 2] && strcmp(words[index+2], "<") && strcmp(words[index+2], "|")) {
						is_redirection_error = TRUE;
						break;
					} else {
						outfile = strdup(words[index + 1]);
						if(-1 == index_first_op) {
							index_first_op = index;
						}
					}
				} else if(strcmp(words[index], "<") == 0) { // input redirection
					if(words[index + 2] && strcmp(words[index + 2], ">") && strcmp(words[index + 2], "|")) {
						is_redirection_error = TRUE;
						break;
					} else {
						if(access(words[index+1], F_OK) == -1) {
							is_redirection_error = TRUE;
							break;
						}
						infile = strdup(words[index+1]);
						if(-1 == index_first_op) index_first_op = index;
					}
				}
				++index;
			}

			if(is_redirection_error) {
				print_error();
				continue;
			}

			int in, out;
			if(index_first_op != -1) {
				// execute redirecting
				if(*outfile) {
					close(STDOUT_FILENO);
					out = open(outfile, O_CREAT | O_WRONLY | O_TRUNC, S_IRWXU/*user can {read, write, execute}*/);
					dup2(out, STDOUT_FILENO);
				}
				if (*infile) {
					in = open(infile, O_RDONLY);
					dup2(in, 0);
				}
				words[index_first_op] = NULL; //remove from command line
			}

			if(is_pipeline) { // if command line is piped
				//indices
				char *first_command[pipe_index + 1];
				char *second_command[num_words - pipe_index];

				// not allowed if pipe is at beginning or end
				if(!pipe_index && pipe_index != (num_words - 1)) {
					int first = TRUE;
					int i,index = 0;
					for(i = 0; i < num_words; i++) {
						if(first) {
							if(i == pipe_index) {
								index = 0;
								first = FALSE;
								continue;
							}
							first_command[index] = strdup(words[i]);
						} else {
							second_command[index] = strdup(words[i]);
						}
						++index;
					}

					//remove from command line
					first_command[pipe_index] = NULL;
					second_command[(num_words - pipe_index) - 1] = NULL;

					// pipe call
					int fd[2]; //declare read write array
					pipe(fd);
					run_pipe(fd, first_command, second_command);

				} else continue;
				
			} else {
				//if not pipeline (regular or internal command)
				if(strcmp(words[0], "cd") == 0) {
					run_cd(words);
				}
				else if(strcmp(words[0], "pwd") == 0) {
					run_pwd(words);
				} else {
					execvp(words[0], words);
					print_error();
				}
			}
		} else {
			print_error();
		}
	}
	return 0;
}
