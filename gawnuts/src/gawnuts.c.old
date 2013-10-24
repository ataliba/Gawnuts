/******************************************************************************
 * Geek Awsome NUTS v. 0.4 - (c) Ataliba Teixeira ( gawnuts@ataliba.eti.br )
 * - This is LICENSED !! Read the LICENSE file to know more about it !!! 
 * - Este software eh licenciado !!! Leia o arquivo LICENSA para maiores 
 *   informacoes
 * Gawnuts is a code based upon AwNuts v. 0.1.
 * for more information about this program, go to the web page of the project 
 * --- http://gawnuts.codigoaberto.org.br ---
 * *****************************************************************************/

/****************************************************************************** 
 * Awsome NUTS v. 0.1 - (c) Mind Booster Noori (marado@student.dei.uc.pt)
 *   - This is LICENSED! Read the LICENSE file to know more about it! -
 *
 * Awsome NUTS v. 0.1 is a code based upon SAMNUTS v. 0.3, which header follows:
 * 
 *******************************************************************************/

/*****************************************************************************
	SAMNUTS v. 0.3 - (c) Mind Booster Noori (marado@student.dei.uc.pt)
		- This is an "internal version", not licensed (yet) -
 *****************************************************************************/


/* For glibc's intl/ instead of the old one: */
#ifndef _GNU_SOURCE
	#define _GNU_SOURCE 1
#endif
#ifdef HAVE_CONFIG_H
	#include <config.h>
#endif
#include <string.h>
#include <unistd.h>

/* If those defined upwards doesn't make sense to you, forget it... it's all
 * because of the new libraries version...
 */

// nuts default 
#define VERSION "2.3.0" //NUTS version

// gawnuts default 
#define CODENAME "GAWNUTS"

// definition of the talker 

#define GAWVERSION "0.4"
#define TALKERNAME "Mundo Gelado"

// other scopes of the program 
#include <stdio.h>
#ifdef _AIX
#include <sys/select.h>
#endif
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h> 
#include <sys/time.h>
#include <fcntl.h>
#include <netdb.h>
#include <netinet/in.h>
#include <signal.h>
#include <time.h>
#include <dirent.h>
#include <sys/sysinfo.h>
#include <sys/time.h>

//#include "openssl/bio.h"
//#include "openssl/err.h"
//#include "openssl/ssl.h"

/****************************************************************
 * File and directory definitions 
 * **************************************************************
 * */
#define DATADIR "datadir"
#define SCREENSDIR "screens"
#define INITFILE "system/init_data"
#define MESSDIR "messboards"
#define MAILDIR "maildir"
#define NEWSFILE "screens/newsfile"
#define MOTD1 "screens/motd1"
#define MOTD2 "screens/motd2"
#define SYSTEM_LOG "systemlogs/syslog"
#define MAIL_LOG "systemlogs/maillog"
#define PASSFILE "system/passfile"
#define USERDATADIR "userdata"
#define HELPDIR "helpfiles"
#define WHOFILE "whofile"
#define BANFILE "banfile"
#define MAPFILE "screens/mapfile"
#define GENFILE "general"
#define BUGFILE "bugfile"
#define SUGESTFILE "sugests"
#define TALKERS "talkers"
#define VERSIONFILE "version"
#define RULESFILE "rules"
#define WHATISTHISFILE "whatisthis"
#define LASTUSERFILE "miscfiles/last_user"
#define UPTIMEFILE "miscfiles/uptime"

#define MAX_LAST_LINES 10


/* level defs */
#include "levels.h"

/* other definitions */
#ifndef FD_SETSIZE
#define FD_SETSIZE 256
#endif
#define ARR_SIZE 2000 
#define MAX_USERS 30 /* MAX_USERS must NOT be greater than FD_SETSIZE - 1 */
#define MAX_AREAS 26 /* max number of areas in the talker */
#define MAX_LAST 10 /* number of lines in the command last */
#define ALARM_TIME 30 /* alarm time in seconds (must not exceed 60) */
#define TIME_OUT 180  /* time out in seconds at login - can't be less than ALARM_TIME */
#define IDLE_MENTION 30  /* Used in check_timeout(). Is in minutes */
#define TOPIC_LEN 35 /* length of the topic string */ 
#define DESC_LEN 29 /* length of the description string */
#define NAME_LEN 16 /* length of the name string */
#define NUM_LINES 15  /* number of lines of conv. to store in areas */
#define PRO_LINES 15  /* number of lines of profile user can store */
#define PRINUM 2   /* no. of users in area befor it can be made private */
#define PASSWORD_ECHO 1 /* set this to 1 if you want passwords echoed */
#define CHAR_MODE_ECHO 0  /* see README about this */
#define SALT "AB"  /* for password encryption */

void sigcall();
char *timeline();

/** Far too many bloody global declarations **/
char *command[]={ 
".quit",".who",".shout",".tell",".listen",".ignore",".look",".go",
".private",".public",".invite",".emote",".areas",".letmein",".write",".read",
".wipe",".topic",".demote",".map",".kill",".shutdown",".search",
".review",".help",".bcast",".news",".prompt",".move",".access",".log",
".semote",".pemote",".desc",".newusers",".version",".entpro",".examine",".passwd",
".dmail",".rmail",".smail",".wake",".promote",".cls", ".addbug", ".delbug", 
".vbug", ".suggest", ".dsuggest", ".vsug", ".talkers", ".rules", ".sayto", "*"
 };

/* Alter this data to suit. It is the level of user that can run each command 
   in the above string array. */
int com_level[]={
0,0,2,1,1,1,0,
1,2, 2,2,0,2,1,
1,1,2,2,3,1,3,3,
2,1,0,2,1,0,2,3,
3,2,1,0,3,0,0,1,
1,1,0,1,2,2,1,1,
3,3,1,3,1,1,1,1     
};

char *syserror="Desculpe - um erro de sistema ocorreu";

char mess[ARR_SIZE];  /* functions use mess to send output */ 
char mess2[ARR_SIZE]; /* for event functions output */
char conv[MAX_AREAS][NUM_LINES][161]; /* stores lines of conversation in area*/
char start_time[30];  /* startup time */
char last_new_user[NAME_LEN];

int PORT,NUM_AREAS,num_of_users=0;
int MESS_LIFE=7;  /* message lifetime in days */
int noprompt,atmos_on,allow_new,com_num;
int syslog_on=1;
int shutd=-1;
int sys_access=1;
int checked=1;  /* see if messages have been checked */
int number_of_bugs=0; // number of bugs in the talker 
int number_of_sugests=0; // number of sugests in the talker
int number_of_accounts=0; // number of accounts in the talker

/* set structure */

/* user structure */
struct {
	char buff[ARR_SIZE],name[NAME_LEN],desc[DESC_LEN]; 
	char login_name[NAME_LEN],login_pass[NAME_LEN];
	char site[80],page_file[80];
	char *pro_start,*pro_end;
	int area,listen,level,file_posn,pro_enter;
	int buffpos,sock,time,vis,invite,last_input;
	int idle_mention,logging_in,attleft,prompt;
	} ustr[MAX_USERS];

/* area structure */
struct {
	char name[NAME_LEN],topic[TOPIC_LEN+1],move[MAX_AREAS];
	int private,status,mess_num,conv_line;
	} astr[MAX_AREAS];

// last structure 
 
struct 
{
   char name[NAME_LEN], status[10];
   int date;
} last_user[MAX_LAST_LINES];


/**** START OF FUNCTIONS ****/

/****************************************************************************
	Main function - 
	Sets up TCP sockets, ignores signals, accepts user input and acts as 
	the switching centre for speach output.
*****************************************************************************/ 
main()
{
struct sockaddr_in bind_addr,acc_addr;
struct hostent *host;
fd_set readmask;  /* readmask for select() */
unsigned int addr;
int listen_sock,accept_sock;
int l,len,area,size,user,new_user,on; 
char inpstr[ARR_SIZE],filename[80],site_num[80];
char *inet_ntoa();  /* socket library function */

printf("\n=======================================================\n              GAWNUTS TALKER BOOTING \n     Ataliba Teixeira < https://github.com/ataliba/Gawnuts >\n=======================================================\n\n");

/* Make old system log backup */
sprintf(filename,"%s.bak",SYSTEM_LOG);
if (rename(SYSTEM_LOG,filename)==-1)
	printf("%s: Warning: Couldn't make old system log backup\n\n", CODENAME);
sprintf(filename,"%s.bak",MAIL_LOG);
if(rename(MAIL_LOG,filename)==-1)
        printf("%s : Warning : Couldn't make old mail log backup\n\n", CODENAME);
write_syslog("*** Talker BOOTING ***\n",0);

/* read system data */
read_init_data();

/* initialize sockets */
printf("Initialising sockets on port %d\n",PORT);
size=sizeof(struct sockaddr_in);
if ((listen_sock=socket(AF_INET,SOCK_STREAM,0))==-1) {
	perror("\nGAWNUTS: Couldn't open listen socket"); 
	write_syslog("BOOT FAILED: Couldn't open listen socket\n",0);
	exit(1);
	}
/* Allow reboots even with TIME_WAITS etc on port */
on=1;
setsockopt(listen_sock,SOL_SOCKET,SO_REUSEADDR,(char *)&on,sizeof(on));

bind_addr.sin_family=AF_INET;
bind_addr.sin_addr.s_addr=INADDR_ANY;
bind_addr.sin_port=htons(PORT);
if (bind(listen_sock,(struct sockaddr *)&bind_addr,size)==-1) {
	perror("\nGAWNUTS: Couldn't bind to port");  
	write_syslog("BOOT FAILED: Couldn't bind to port\n",0);
	exit(1);
	}
if (listen(listen_sock,20)==-1) {
	perror("\nGAWNUTS: Listen error"); 
	write_syslog("BOOT FAILED: Listen error",0);
	exit(1);
	}

/* initialize functions */
puts("=> Initialising structures");
init_structures();
puts("=> Checking for out of date messages");
check_mess(1);
messcount();
puts("=> Processing users ... ");
puts("--> Counting the users of this talker ... ");
counting_user(0);
puts("--> Processing the last user of this talker ... ");
process_last_user();
   
/* Set socket to non-blocking. Not really needed but it does no harm. */
fcntl(listen_sock,F_SETFL,O_NDELAY);

/* Set to run in background automatically  - no '&' needed */
switch(fork()) {
	case -1:
		perror("\nGAWNUTS: Fork failed"); 
		write_syslog("BOOT FAILED: Fork failed\n",0);
		exit(1);
	case 0: break;  /* child becomes server */
	default: sleep(1); exit(0);  /* kill parent */
	}

/* log startup */
sprintf(mess,"** Talker BOOTED (PID %d) on %s\n",getpid(),timeline(1));
write_syslog(mess,0);
strcpy(start_time,timeline(1)); /* record boot time */
unlink(WHOFILE);
printf("=======================================================\n=> Process ID: %d\n=======================================================\n=> The Server is running\n=======================================================\n\n",getpid());

/* close stdin, out & err to free up some descriptors */
close(0); 
close(1);
close(2); 

/* Set up alarm & ignore all possible signals. Ok so we shouldnt really ignore 
   signals but I can't think of any usefull trap function to write. */
reset_alarm();
signal(SIGILL,SIG_IGN);
signal(SIGTRAP,SIG_IGN);
signal(SIGIOT,SIG_IGN);
signal(SIGBUS,SIG_IGN);
signal(SIGSEGV,SIG_IGN);
signal(SIGTSTP,SIG_IGN);
signal(SIGCONT,SIG_IGN);
signal(SIGHUP,SIG_IGN);
signal(SIGINT,SIG_IGN);
signal(SIGQUIT,SIG_IGN);
signal(SIGABRT,SIG_IGN);
signal(SIGFPE,SIG_IGN);
signal(SIGTERM,SIG_IGN);
signal(SIGURG,SIG_IGN);
signal(SIGPIPE,SIG_IGN);
signal(SIGTTIN,SIG_IGN);
signal(SIGTTOU,SIG_IGN);
signal(SIGXCPU,SIG_IGN);


/**** Main program loop. Its a bit too long but what the hell...  *****/
while(1) {
	noprompt=0;
	FD_ZERO(&readmask);

	/* set up readmask */
	for (user=0;user<MAX_USERS;++user) {
		if (ustr[user].sock==-1) continue;
		FD_SET(ustr[user].sock,&readmask);
		}
	FD_SET(listen_sock,&readmask);

	/* wait */
	if (select(FD_SETSIZE,&readmask,0,0,0)==-1) continue;

	/* check for connection to listen socket */
	if (FD_ISSET(listen_sock,&readmask)) {
		accept_sock=accept(listen_sock,(struct sockaddr *)&acc_addr,&size);
		more(-1,accept_sock,MOTD1); /* send first message of the day */
	        
	        sprintf(mess,"Esta eh a casa de %d usuarios \n\r",number_of_accounts);
	        write_user(user,mess);
	        sprintf(mess,"Nosso ultimo usuario cadastrado foi ");
	        write_user(user,mess);
	        sprintf(mess,"%s \n\r",last_new_user);
	        write_user(user,mess);
	   
	        if (!sys_access) {
			strcpy(mess,"\n\rDesculpe, neste momento o talker nao esta aceitando novas conexoes. Caso deseje usar um talker, tente a Selva\n\n\r");
			write(accept_sock,mess,strlen(mess));
			close(accept_sock);
			continue;
			}
		if ((new_user=find_free_slot())==-1) {
			strcpy(mess,"\n\rDesculpe, neste momento o talker nao esta aceitando novas conexoes \n\rCaso deseje realmente usar um talker, tente a conexao no NerdTalker - telnet cypher.ataliba.eti.br 3336\n\n\r");
			write(accept_sock,mess,strlen(mess));
			close(accept_sock);
			continue;
			}

		/* get new user internet site */
		strcpy(site_num,inet_ntoa(acc_addr.sin_addr)); /* get number addr. */
		addr=inet_addr(site_num);
		if ((host=gethostbyaddr((char *)&addr,4,AF_INET)))
			strcpy(ustr[new_user].site,host->h_name); /* copy name addr. */
		else strcpy(ustr[new_user].site,site_num);


		ustr[new_user].sock=accept_sock;
		ustr[new_user].last_input=time((time_t *)0);
		ustr[new_user].logging_in=3;
		ustr[new_user].attleft=3;
		echo_on(user);
		write_user(new_user,"\n\rDigite o seu nome: ");
		} 

	/** cycle through users **/
	for (user=0;user<MAX_USERS;++user) {
		if (ustr[user].sock==-1) continue;
		area=ustr[user].area;

		/* see if any data on socket else continue */
		if (!FD_ISSET(ustr[user].sock,&readmask)) continue;
	
		inpstr[0]=0;
		if (!(len=read(ustr[user].sock,inpstr,sizeof(inpstr)))) {
			user_quit(user);  continue;
			}
		/* ignore control code replies */
		if ((unsigned char)inpstr[0]==255) continue;

		/* see if delete key pressed in char. mode */
		if (inpstr[0]==8 || inpstr[0]==127) {
			if (ustr[user].buffpos) {
				ustr[user].buffpos--;  write_user(user,"\b \b");
				ustr[user].buff[ustr[user].buffpos]=0;
				}
			continue;
			}

          /* copy input into buffer - allows line or char. mode clients */
          for(l=0;l<len;++l) {
               ustr[user].buff[ustr[user].buffpos+l]=inpstr[l];
               if (inpstr[l]<32 || ustr[user].buffpos+l+2==ARR_SIZE) {
                    if (ustr[user].buffpos) write_user(user,"\n\r");
                    goto GOT_LINE;
                    }
               }
          if (CHAR_MODE_ECHO && (!ustr[user].logging_in || ustr[user].logging_in==3 || PASSWORD_ECHO)) write(ustr[user].sock,inpstr,len);
          ustr[user].buffpos=ustr[user].buffpos+l;
          continue;

          GOT_LINE:
		/* copy buffer back into inpstr */
		strcpy(inpstr,ustr[user].buff);
          terminate(inpstr);
          ustr[user].buff[0]=0;  ustr[user].buffpos=0;
		ustr[user].last_input=time((time_t *)0);  /* ie now */
		ustr[user].idle_mention=0;

		/* see if user is logging in */
		if (ustr[user].logging_in) { 
			login(user,inpstr);  continue; 
			}

		/* see if user is reading a file */
		if (ustr[user].file_posn) {
			if (inpstr[0]=='q' || inpstr[0]=='Q') {
				ustr[user].file_posn=0;  prompt(user);
				continue;
				}
			if (more(user,ustr[user].sock,ustr[user].page_file)==2) prompt(user);
			continue;
			}

		/* see if input is answer to shutdown query */
		if (shutd==user && inpstr[0]!='y') {
			shutd=-1;  prompt(user); continue;
			}
		if (shutd==user && inpstr[0]=='y') shutdown_talker(user,listen_sock);
		if (!inpstr[0] || nospeech(inpstr)) continue; 

		/* see if user is entering profile data */
		if (ustr[user].pro_enter) {
			enter_pro(user,inpstr);  continue;
			}

		/* deal with any commands */
		com_num=get_com_num(inpstr);
		if (com_num==-1 && inpstr[0]=='.') {
			write_user(user,"=> Comando desconhecido!");
			prompt(user);  continue;
			}
		if (com_num!=-1) {
			exec_com(user,inpstr,ustr[user].sock);
			if (!com_num || noprompt) continue;  /* com 0 is quit */
			prompt(user); continue;
			} 

		/* send speech to speaker & everyone else in same area */
		if (!instr(inpstr,"help")) 
			write_user(user,"* Se precisa de ajuda  .. digite .help  *\n\r");
		say_speech(user,inpstr);
		prompt(user);
		}
	} /* end while */
}


/************************* MISCELLANIOUS FUNCTIONS ***************************/

/*** Say user speech ***/
say_speech(user,inpstr)
int user;
char *inpstr;
{
char type[10];
switch(inpstr[strlen(inpstr)-1]) {
	case '?': strcpy(type,"pergunta");  break;
	case '!': strcpy(type,"exclama");  break;
	case ':)': strcpy(type,"sorri"); break;
	default : strcpy(type,"diz");
	}
sprintf(mess,"Voce %s: %s",type,inpstr);
write_user(user,mess);
if (!ustr[user].vis) 
	sprintf(mess,"Uma voz animalesca diz: %s\n\r",inpstr);
else sprintf(mess,"%s diz: %s\n\r",ustr[user].name,inpstr);
write_alluser(user,mess,0,0);
record(mess,ustr[user].area);
}



/*** Print prompt ***/
prompt(user)
int user;
{
int mins,hours;
time_t tm_num;
char timestr[30];

if (ustr[user].prompt) {
	time(&tm_num);
	midcpy(ctime(&tm_num),timestr,11,15);
	mins=((int)tm_num-ustr[user].time)/60;
	hours=mins/60;  mins=mins%60;
	sprintf(mess,"\n\r[Mundo Gelado: %s, %02d:%02d]\n\r",timestr,hours,mins);
	write_user(user,mess);
	return;
	}
write_user(user,"\n\r");
}



/*** Record speech and emotes ***/
record(string,area)
char *string;
int area;
{
string[160]=0;
strcpy(conv[area][astr[area].conv_line],string);
astr[area].conv_line=(++astr[area].conv_line)%NUM_LINES;
}



/*** Put string terminate char. at first char < 32 ***/
terminate(str)
char *str;
{
int u;
for (u=0;u<ARR_SIZE;++u)  {
	if (*(str+u)<32) {  *(str+u)=0;  return;  } 
	}
str[u-1]=0;
}



/*** convert string to lower case ***/
strtolower(str)
char *str;
{
while(*str) {  *str=tolower(*str);  str++; }
}



/*** check for empty string ***/
nospeech(str)
char *str;
{
while(*str) {  if (*str>32) return 0;  str++;  }
return 1;
}



/** read in initialize data **/
read_init_data()
{
char filename[80],line[80],status[10];
char *initerror="BOOT FAILED: Error in init file\n";
int a;
FILE *fp;

printf("Reading init data from file ./%s\n",INITFILE);
sprintf(filename,"%s",INITFILE);
if (!(fp=fopen(filename,"r"))) {
	perror("\nGAWNUTS: Couldn't read init file");
	write_syslog("BOOT FAILED: Couldn't read init file\n",0);
	exit(1);
	}

fgets(line,80,fp);

/* read in important system data & do a check of some of it */
atmos_on=-1;  syslog_on=-1;  MESS_LIFE=-1;  allow_new=-1;
sscanf(line,"%d %d %d %d %d %d",&PORT,&NUM_AREAS,&atmos_on,&syslog_on,&allow_new,&MESS_LIFE);
if (PORT<1 || PORT>65535 || NUM_AREAS>MAX_AREAS || atmos_on<0 || atmos_on>1 || syslog_on<0 || syslog_on>1 || MESS_LIFE<1 || allow_new<0 || allow_new>1) {
	fprintf(stderr,"\nGAWNUTS: Error in init file on line 1\n");
	write_syslog(initerror,0);  exit(1);
	}

/* read in descriptions and joinings */
for (a=0;a<NUM_AREAS;++a) {
	fgets(line,80,fp);
	astr[a].name[0]=0;  astr[a].move[0]=0;  status[0]=0;  
	sscanf(line,"%s %s %s",astr[a].name,astr[a].move,status);
	astr[a].status=atoi(status);
	if (!astr[a].name[0] || !astr[a].move[0] || !status[0] || astr[a].status<0 || astr[a].status>2) {
		fprintf(stderr,"\nGAWNUTS: Error in init file on line %d\n",a+2);
		write_syslog(initerror,0);  exit(1);
		}
	if (astr[a].status==2) astr[a].private=1;
	else astr[a].private=0;
	}
fclose(fp);
}



/*** Init user & area structures ***/
init_structures()
{
int a,n,u;

for (u=0;u<MAX_USERS;++u) {
	ustr[u].area=-1;  ustr[u].listen=1;
	ustr[u].invite=-1;  ustr[u].level=0;
	ustr[u].vis=1;  ustr[u].logging_in=0; 
	ustr[u].buffpos=0;  ustr[u].sock=-1; 
	ustr[u].buff[0]=0;
	}

for (a=0;a<NUM_AREAS;++a) {
	for (n=0;n<NUM_LINES;++n) conv[a][n][0]=0;
	astr[a].conv_line=0;  astr[a].topic[0]=0;
	}
}



/*** count no. of messages (counts no. of newlines in message files) ***/
messcount()
{
FILE *fp;
char c,filename[40];
int a;

puts("--> Counting messages ... ");
for(a=0;a<NUM_AREAS;++a) {
	astr[a].mess_num=0;
	sprintf(filename,"%s/board%d",MESSDIR,a);
	if (!(fp=fopen(filename,"r"))) continue; 
	while(!feof(fp)) {
		c=getc(fp);
		if (c=='\n') astr[a].mess_num++;
		}
	fclose(fp);
	}


puts("--> Counting bugs ... ");

sprintf(filename,"%s/%s",DATADIR,BUGFILE);

if(!(fp=fopen(filename,"r"))) return; 
 
while(!feof(fp))
 {
    c=getc(fp);
    if(c=='\n') number_of_bugs++;
 }

fclose(fp); 

puts("--> Counting suggests ... ");

sprintf(filename,"%s/%s",DATADIR,SUGESTFILE);     
if(!(fp=fopen(filename,"r"))) return;

while(!feof(fp))
 {
    c=getc(fp);
    if(c=='\n') number_of_sugests++;
 }

fclose(fp);   
   
}

/*** add the last new user in the program memory and in a file, to read in the 
 *** boot of the program */

add_last_new_user(user)
char user[NAME_LEN];
{
   
   FILE *archive;
   char name[NAME_LEN], filename[30];
   
   sprintf(filename,"%s",LASTUSERFILE);
   write_syslog(filename,0);
   if(!(archive = fopen(filename,"w")))
     {
	sprintf(mess,"ERROR : couldn't open %s to write \n",LASTUSERFILE);
	write_syslog(mess);
	fclose(archive);
     }
   else
     {
	sprintf(mess,"SUCCESS : open %s to write \n",LASTUSERFILE);
	write_syslog(mess);
     }
   
   sprintf(mess,"%s",user);
   
   fputs(user,archive);
   
   sprintf(last_new_user,user);
   
   fclose(archive);
}

/* couting users of the talker */

counting_user(int i)
{
   DIR *dir;
   struct dirent *dp;
   
   number_of_accounts = 0;
   
   if((dir = opendir(USERDATADIR)) == NULL)
     {
	sprintf(mess,"=> GAWNUTS : impossivel abrir o diretorio de userfiles para a funcao counting_user");
	write_user(mess);
	sprintf(mess,"GAWNUTS : erro ao abrir o diretorio %s para a funcao counting_users\n",USERDATADIR);
	write_syslog(mess,1);
     }
   
   while((dp = readdir(dir)))
     {
	if (!strcmp(dp->d_name,".") || !strcmp(dp->d_name,"..") || !strcmp(dp->d_name,".D")) continue;
	
	if(strstr(dp->d_name,".D"))
	  {
	     number_of_accounts++;
	  }
     }
   
   (void)closedir(dir);
 }

/*** insert in the memory the last new user of the talker ... ***/

process_last_user()
{
   FILE *archive;
   char filename[30], name[NAME_LEN];
   
   sprintf(filename,"%s",LASTUSERFILE);
   
   if(!(archive = fopen(filename,"r")))
     {
	puts("ERROR : couldn't open Last new User file to read ");
	fclose(archive);
	return;
     }
   
   fscanf(archive,"%s",name);
   
   sprintf(last_new_user,"%s",name);
   
   fclose(archive);
   
}

/*** This is login function - first part of prog users encounter ***/
login(user,inpstr)
int user;
char *inpstr;
{
char line[81],name[ARR_SIZE],passwd[ARR_SIZE];
char name2[NAME_LEN],passwd2[NAME_LEN];
int f=0;
FILE *fp;

passwd[0]=0;  passwd2[0]=0;

switch(ustr[user].logging_in) {
	case 1: check_pass(user,inpstr);  return;

	case 2:
	/* See if user entering password ... */
	passwd[0]=0;
	sscanf(inpstr,"%s",passwd);
	if (strlen(passwd)>NAME_LEN-1) {
		write_user(user,"\n\r=> Password muito grande...\n\n\r");  
		attempts(user);  return;
		}
	if (strlen(passwd)<4) {
		write_user(user,"\n\r=> Password muito pequena...\n\n\r");
		attempts(user);  return;
		}

	/* convert name to lowercase with first letter uppercase */
	strtolower(ustr[user].login_name);
	ustr[user].login_name[0]=toupper(ustr[user].login_name[0]);

	/* open password file to read */
	if (!(fp=fopen(PASSFILE,"r"))) {
		write_syslog("WARNING: Couldn't open password file to read in login()\n",0);
		goto NEW_USER;
		}

	/* search for login */
	while(!feof(fp)) {
		fgets(line,80,fp);
		sscanf(line,"%s %s",name2,passwd2);
		if (/*0 !=*/ !strcmp(ustr[user].login_name,name2) 
				&& strcmp(crypt(passwd,SALT),passwd2) /*== 0*/) {
			write_user(user,"\n\r=> Login Incorreto!\n\n\r");
			attempts(user); fclose(fp);  return; 
			}
		if (!strcmp(ustr[user].login_name,name2) && !strcmp(crypt(passwd,SALT),passwd2)) {
			fclose(fp);  echo_on(user);  add_user(user); 
			return;
			}
		}

	/** deal with new user **/
	fclose(fp);
	NEW_USER:
	if (!allow_new) {
		write_user(user,"\n\r=> Login incorreto!\r\n\n");
		attempts(user);  return;
		}
	write_user(user,"\n\rNovo usuario...\n\rDigite novamente a passwd: ");
	strcpy(ustr[user].login_pass,passwd);
	ustr[user].logging_in=1;
	return;
   

	case 3:
	/* User has entered his login name... */
	name[0]=0;
	sscanf(inpstr,"%s",name);
	if (!strcmp(name,"quit")) {
		write_user(user,"\n\r=> Abandonando o Mundo Gelado...\n\n\r");
		user_quit(user);  return;
		}
	/* This allows someone to see who's on from the login prompt so they 
	   needn't bother to log in if their mates arn't on. I think its a nice
	   idea, you may find it intrusive , remove it if you must */
	if (!strcmp(name,"who")) {
		who(user,0);  write_user(user,"\n\rDigite um nome: ");  return;
		}
        
        if(!strcmp(name,"what")) 
         {
	    what_is_this(user);
	    write_user(user,"\n\rDigite um nome: ");
	    return;
	 }
   
	
	if (name[0]<32 || !strlen(name)) {
		write_user(user,"\n\rHey, deixe de onda, digite um nome: ");  return;
		}
	if (strlen(name)<3) {
		write_user(user,"=> Este nome e muito pequeno!\n\n\r");
		attempts(user);  return;
		}
	if (strlen(name)>NAME_LEN-1) {
		write_user(user,"=> Ei, nao exagere, o nome esta muito grande...\n\n\r");
		attempts(user);  return;
		}
	if (!strcmp(name,"Someone") || !strcmp(name,"someone")) {
		write_user(user,"=> Esse nome nao eh valido!\n\n\r");
		attempts(user);  return;
		}
	
	/* see if only letters in login */
	for (f=0;f<strlen(name);++f) {
		if (!isalpha(name[f])) {
			write_user(user,"=> Desculpe, mas so aceitamos letras nos nomes...\n\n\r");
			attempts(user);  return;
			}
		}
	strcpy(ustr[user].login_name,name);
	ustr[user].logging_in=2;
	write_user(user,"Digite a passwd: ");
	}
}



/*** Check user password ***/
check_pass(user,inpstr)
int user;
char *inpstr;
{
FILE *fp;
char passwd[ARR_SIZE];

sscanf(inpstr,"%s",passwd);
if (strcmp(ustr[user].login_pass,passwd)) {
	write_user(user,"\n\r=> Password errada\n\n\r");
	ustr[user].login_pass[0]=0;
	attempts(user);  return;
	}
if (!(fp=fopen(PASSFILE,"a"))) {
	echo_on(user);
	sprintf(mess,"\n\r%s : No momento estamos tendo problemas ... tente mais tarde.\n\n\r",syserror);
	write_user(user,mess);
	write_syslog("ERROR: Couldn't open password file to append in check_pass()\n",0);
	user_quit(user);
	return;
	}
fprintf(fp,"%s %s\n",ustr[user].login_name,crypt(passwd,SALT));
echo_on(user);
sprintf(mess,"Nova id \"%s\" criada\n",ustr[user].login_name);
write_syslog(mess,1);
add_last_new_user(ustr[user].login_name);
add_user(user);
fclose(fp);
}



/*** check to see if user has had max login attempts ***/
attempts(user)
int user;
{
echo_on(user);
if (!--ustr[user].attleft) {
	write_user(user,"\n\r=> Hey, voce atingiu o numero maximo de tentativas... <=\n\n\r");
	user_quit(user); 
	return;
	}
ustr[user].logging_in=3;
write_user(user,"Digite um nome: ");
}



/*** Tell telnet not to echo characters - for password entry ***/
echo_off(user)
int user;
{
char seq[4];

if (PASSWORD_ECHO) return;
sprintf(seq,"%c%c%c",255,251,1);
write_user(user,seq);
}



/*** Tell telnet to echo characters ***/
echo_on(user)
int user;
{
char seq[4];

if (PASSWORD_ECHO) return;
sprintf(seq,"%c%c%c",255,252,1);
write_user(user,seq);
}

	

/*** Return a time string ***/
char *timeline(len)
{
time_t tm_num;
static char timestr[30];

time(&tm_num);
if (len) {
	strcpy(timestr,ctime(&tm_num));
	timestr[strlen(timestr)-1]=0;  /* get rid of nl */
	}
else midcpy(ctime(&tm_num),timestr,4,15);
return timestr;
}



/*** Send a string to system log ***/
write_syslog(str,write_time)
char *str;
int write_time;
{
FILE *fp;
time_t tm_num;
char timestr[15],line[160];

if (!syslog_on || !(fp=fopen(SYSTEM_LOG,"a"))) return;
if (write_time) {
	time(&tm_num);
	midcpy(ctime(&tm_num),timestr,4,15);
	sprintf(line,"%s: %s",timestr,str);

	fputs(line,fp);
	}
else fputs(str,fp);
fclose(fp);
}

/*** Send a string to mail log, this function is a copy of the function 
 *** write_syslog */

write_maillog(str,write_time)
char *str;
int write_time;
{
FILE *fp;
time_t tm_num;
char timestr[15],line[160];

if (!syslog_on || !(fp=fopen(MAIL_LOG,"a"))) return;
if (write_time) {
	time(&tm_num);
	midcpy(ctime(&tm_num),timestr,4,15);
	sprintf(line,"%s: %s",timestr,str);

	fputs(line,fp);
	}
else fputs(str,fp);
fclose(fp);
}



/*** write user sends string down socket ***/
write_user(user,str)
char *str;
int user;
{
write(ustr[user].sock,str,strlen(str));
}



/*** finds next free user number ***/
find_free_slot()
{
int u;

if (num_of_users==MAX_USERS)  return -1;
for (u=0;u<MAX_USERS;++u) if (ustr[u].sock==-1) return u;
return -1;
}



/*** set up data for new user if he can get on ***/ 
add_user(user)
int user;
{
int i,u;
char filename[80],timestr[31],sitestr[81],levstr[3],type[10];
FILE *fp;

timestr[0]=0;

/* see if already logged on */
if ((u=get_user_num(ustr[user].login_name))!=-1 && u!=user) {
	write_user(user,"\n\r=> Voce ja esta conectado - trocando de sessao...\n\n\r");
	/* switch user instances */
	close(ustr[u].sock);
	ustr[u].sock=ustr[user].sock;
	ustr[user].name[0]=0;
	ustr[user].area=-1;
	ustr[user].sock=-1;
	ustr[user].logging_in=0;
	look(u);  prompt(u);
	return;
	}


/* reset user structure */
strcpy(ustr[user].name,ustr[user].login_name);
ustr[user].area=0;
ustr[user].listen=1;
ustr[user].vis=1;
ustr[user].time=time((time_t *)0);
ustr[user].invite=-1;
ustr[user].last_input=time((time_t *)0);
ustr[user].logging_in=0;
ustr[user].file_posn=0;
ustr[user].pro_enter=0;
ustr[user].prompt=0;
num_of_users++;

/* Set socket to non-blocking. Not really needed but it does no harm. */
fcntl(ustr[user].sock,F_SETFL,O_NDELAY); 

/* Load user data */
sprintf(filename,"%s/%s.D",USERDATADIR,ustr[user].name);
if (!(fp=fopen(filename,"r"))) {
	ustr[user].level=NEWBIE;
	strcpy(ustr[user].desc,"- um novato tremer nos polos...");
	}
else {
	/* load data */
	fgets(timestr,30,fp);
	fgets(sitestr,80,fp);
	fgets(ustr[user].desc,80,fp);
	fgets(levstr,2,fp);	
	fclose(fp);
	ustr[user].level=atoi(levstr);
	/* remove newlines */
	timestr[strlen(timestr)-1]=0; 
	ustr[user].desc[strlen(ustr[user].desc)-1]=0;
	}

/* send intro stuff */

if (PASSWORD_ECHO) {
	for(i=0;i<6;++i) write_user(user,"\n\n\n\n\n\n\n\n\n\n\r");
	}
switch(ustr[user].level) {
	case NEWBIE: strcpy(type,"BONECO_DE_NEVE ");  break;
	case USER  : strcpy(type,"FOCA ");  break;
	case WIZARD: strcpy(type,"URSO_POLAR ");  break;
	case GOD   : strcpy(type,"TUX ");
	}
sprintf(mess,"\n\n\n\rBem vindo  %s%s\n\n\r",type,ustr[user].name);
write_user(user,mess);
   if (timestr[0]) {
	sprintf(mess,"Conectou-se pela ultima vez em %s de %s\n\r",timestr,sitestr);
	write_user(user,mess);
	}
if(ustr[user].level == GOD)
     {
	sprintf(mess,"Voce tem %d bugs a ler e %d sugestoes a serem lidas \n\n\r",number_of_bugs,number_of_sugests);
	write_user(user,mess);
     }
   
/* send 2nd message of the day */
more(-1,ustr[user].sock,MOTD2);

/* check for mail */
sprintf(filename,"%s/%s.M",MAILDIR,ustr[user].name);
look(user);
if (fp=fopen(filename,"r")) {
	write_user(user,"\n\r** EMAIL NOVO !!! **");
	fclose(fp);
	}
if (ustr[user].level==NEWBIE){
	write_user(user,"\n\r** Digite .entpro e registre-se no Mundo dos Pinguins !!! **\n\r");
}	
prompt(user);

/* send message to other users and to file */
if (ustr[user].name[0]!='?') {
	sprintf(mess,"=>[ ACABOU DE ENTRAR ]: %s %s\n\r",ustr[user].name,ustr[user].desc);
	write_alluser(user,mess,1,0);
	sprintf(mess,"%s ligou-se ao %s\n",ustr[user].name,TALKERNAME);
	write_syslog(mess,1);
	}
whowrite();
}


/*** Page a file out to user like unix "more" command ***/
more(user,socket,filename)
int user,socket;
char *filename;
{
int i,num_chars=0,lines=0,retval=1;
FILE *fp;
if (!(fp=fopen(filename,"r"))) {
	ustr[user].file_posn=0;  return 0;
	}
/* jump to reading posn in file */
if (user!=-1) fseek(fp,ustr[user].file_posn,0);

/* loop until end of file or end of page reached */
mess[0]=0;
while(!feof(fp) && lines<23) {
	lines+=strlen(mess)/80+1;
	num_chars+=strlen(mess);
	for (i=0;i<strlen(mess);++i) {
		if (mess[i]=='\n') write(socket,"\n\r",2);
		else write(socket,&mess[i],1);
		}
	fgets(mess,sizeof(mess)-1,fp);
	}
if (user==-1) goto SKIP;
if (feof(fp)) {
	ustr[user].file_posn=0;  noprompt=0;  retval=2;
	}
else  {
	/* store file position and file name */
	ustr[user].file_posn+=num_chars;
	strcpy(ustr[user].page_file,filename);
	write_user(user,"*** PRESS RETURN OR Q TO QUIT: ");
	noprompt=1;
	}
SKIP:
fclose(fp);
return retval;
}


/*** get user number using name ***/
get_user_num(name)
char *name;
{
int u;

for (u=0;u<MAX_USERS;++u) 
	if (!strcmp(ustr[u].name,name) && ustr[u].area!=-1) return u;
return -1;
}



/*** return pos. of second word in inpstr ***/
char *remove_first(inpstr)
char *inpstr;
{
char *pos=inpstr;
while(*pos<33 && *pos) ++pos;
while(*pos>32) ++pos;
while(*pos<33 && *pos) ++pos;
return pos;
}



/*** sends output to all areas if area==1, else only users in same area ***/
write_alluser(user,str,area,send_to_user)
char *str;
int user,area,send_to_user;
{
int u;

str[0]=toupper(str[0]);
for (u=0;u<MAX_USERS;++u) {
	/* com_num 26 is bcast command ,30 is close , 31 is open */
	if (!ustr[u].listen && com_num!=26 && com_num!=30 && com_num!=31) continue;
	if ((!send_to_user && user==u) || ustr[u].area==-1) continue;
	if (ustr[u].area==ustr[user].area || area)  write_user(u,str);
	}
}



/*** gets number of command entered (if any) ***/
get_com_num(inpstr)
char *inpstr;
{
char comstr[ARR_SIZE];
int com;

sscanf(inpstr,"%s",comstr);

/*Place to code command aliases... */

if (!strcmp(comstr,";") || !strcmp(comstr,":")) strcpy(comstr,".emote"); 
if (!strcmp(comstr,"!")) strcpy(comstr,".semote");
if (!strcmp(comstr,">")) strcpy(comstr,".tell");
com=0;
while(command[com][0]!='*') {
	if (!instr(command[com],comstr) && strlen(comstr)>1) return com;
	++com;
	}
return -1;
}



/*** alter who file (used by who daemon) ***/
whowrite()
{
int u;
FILE *fp;

unlink(WHOFILE);
if (!num_of_users)  return;

if (!(fp=fopen(WHOFILE,"w"))) {
	write_syslog("ERROR: Couldn't open whofile to write in whowrite()\n",0);  return;
	}

/* write user names and descriptions to the file */
for (u=0;u<MAX_USERS;++u) {
	if (ustr[u].area==-1)  continue;
	sprintf(mess,"%s %s\n",ustr[u].name,ustr[u].desc);
	fputs(mess,fp);
	}
fclose(fp);
}



/**** mid copy copies chunk from string strf to string strt
	 (used in write_board & prompt) ***/
midcpy(strf,strt,fr,to)
char *strf,*strt;
int fr,to;
{
int f;
for (f=fr;f<=to;++f) {
	if (!strf[f]) { strt[f-fr]='\0';  return; }
	strt[f-fr]=strf[f];
	}
strt[f-fr]='\0';
}




/*** searches string ss for string sf ***/
instr(ss,sf)
char *ss,*sf;
{
int f,g;
for (f=0;*(ss+f);++f) {
	for (g=0;;++g) {
		if (*(sf+g)=='\0' && g>0) return f;
		if (*(sf+g)!=*(ss+f+g)) break;
		} 
	} 
return -1;
}



/*** Finds number or users in given area ***/
find_num_in_area(area)
int area;
{
int u,num=0;
for (u=0;u<MAX_USERS;++u) 
	if (ustr[u].area==area) ++num;
return num;
}


/*** See if user exists in password file ***/
user_exists(user,name)
int user;
char *name;
{
char line[80],name2[NAME_LEN];
FILE *fp;

if (!(fp=fopen(PASSFILE,"r"))) {
	sprintf(mess,"%s : Nao consigo abrir o seu arquivo de password...",syserror);
	write_user(user,mess);
	write_syslog("ERROR: Couldn't open password file to read in user_exists()\n",0);
	return 0;
	}
while(!feof(fp)) {
	fgets(line,80,fp);
	sscanf(line,"%s ",name2);
	if (!strcmp(name,name2)) {  fclose(fp);  return 1;  }
	}
fclose(fp);
return 0;
}



/*** Save user stats ***/
save_stats(user)
int user;
{
time_t tm_num;
char timestr[30],filename[80];
FILE *fp;

if (!strcmp(ustr[user].name,"?")) return 1;
sprintf(filename,"%s/%s.D",USERDATADIR,ustr[user].name);
if (!(fp=fopen(filename,"w"))) return 0;
time(&tm_num);
strcpy(timestr,ctime(&tm_num));
fprintf(fp,"%s%s\n%s\n%d\n",timestr,ustr[user].site,ustr[user].desc,ustr[user].level);
fclose(fp);
return 1;
}



/**************************** COMMAND FUNCTIONS *******************************/

/*** Call command function or execute command directly ***/
exec_com(user,inpstr)
int user;
char *inpstr;
{
/* see if superuser command */
if (ustr[user].level<com_level[com_num]) {
	write_user(user,"Voce nao eh grande o suficiente para fazer isto...");
	return;
	}
inpstr=remove_first(inpstr);  /* get rid of commmand word */

switch(com_num) {
	case 0 : user_quit(user); break;
	case 1 : who(user,0); break; /* who */
	case 2 : shout(user,inpstr); break;
	case 3 : tell(user,inpstr); break;
	case 4 : 
		if (ustr[user].listen) {
			write_user(user,"Ja esta ouvindo a todos ?");
			return;
			}
		write_user(user,"Passa a ouvir todos ...");
		sprintf(mess,"%s passou a ouvir tudo.\n\r",ustr[user].name);
		write_alluser(user,mess,0,0);
		ustr[user].listen=1;  break;
	case 5 : 
		if (!ustr[user].listen) {
			write_user(user,"Voce ja esta sendo um antisocial!");
			return;
			}
		write_user(user,"Passa a ignorar todos os seus amigos pinguins...");
		sprintf(mess,"%s esta a ignorar tudo...\n\r",ustr[user].name);
		write_alluser(user,mess,0,0);
		ustr[user].listen=0;  break;
	case 6 : look(user);  break;
	case 7 : go(user,inpstr,0);  break;
	case 8 : area_access(user,1);  break; /* private */
	case 9 : area_access(user,0);  break; /* public */
	case 10: invite_user(user,inpstr);  break;
	case 11: emote(user,inpstr);  break;
	case 12: areas(user);  break;
	case 13: go(user,inpstr,1);  break;  /* letmein */
	case 14: write_board(user,inpstr);  break;
	case 15: read_board(user);  break;
	case 16: wipe_board(user,inpstr);  break;
	case 17: set_topic(user,inpstr);  break;
        case 18: demote(user,inpstr);  break;
        case 19:
             if (!more(user,ustr[user].sock,MAPFILE))
               write_user(user,"Nao ha nenhum mapa ... avise ao Ironwood!");
             break;
        case 20: kill_user(user,inpstr);  break;
	case 21: shutdown_talker(user,0);  break;
	case 22: search(user,inpstr);  break;
	case 23: review(user);  break;
	case 24: help(user,inpstr);  break;
	case 25: broadcast(user,inpstr);  break;
	case 26: 
		write_user(user,"\n\r*** Novidades ***\n\n\r");
		if (!more(user,ustr[user].sock,NEWSFILE)) 
			write_user(user,"Nao ha novidades ... Avise ao Ironwood!");
		break;
	case 27:
		if (ustr[user].prompt) {
			write_user(user,"Prompt OFF");  
			ustr[user].prompt=0;  break;
			}
		write_user(user,"Prompt ON");
		ustr[user].prompt=1;  break;
        case 28: move(user,inpstr);  break;
	case 29:
		if (sys_access) {
     		write_area(-1,"*** O MUNDO DOS PINGUINS NAO ESTA ACEITANDO NOVOS LOGINS  ***\n\r");
			sprintf(mess,"%s CLOSED the system\n",ustr[user].name);
			write_syslog(mess,1);  sys_access=0;  break;
     		}
		write_area(-1,"*** O MUNDO DOS PINGUINS ESTA ACEITANDO NOVOS LOGINS ***\n\r");
		sprintf(mess,"%s ABRIU o Mundos dos PINGUINS!\r\n",ustr[user].name);
		write_syslog(mess,1);  sys_access=1;  break;
	case 30: 
		if (syslog_on) {
			write_user(user,"Sistema de logging OFF");
			sprintf(mess,"%s turned logging OFF\n",ustr[user].name);
			write_syslog(mess,1);  syslog_on=0;  break;
			}
		write_user(user,"Sistema de logging ON");  syslog_on=1;
		sprintf(mess,"%s turned logging ON\n",ustr[user].name);
		write_syslog(mess,1);  break;
        case 31: semote(user,inpstr);  break;
        case 32: pemote(user,inpstr);  break;
        case 33: set_desc(user,inpstr);  break;
	case 34: 
		if (allow_new) {
			write_user(user,"Novos usuarios? NAO!");  allow_new=0;
			sprintf(mess,"%s DISALLOWED new users\n",ustr[user].name);
			write_syslog(mess,1);  break;
			}
		write_user(user,"Abre o Mundo dos Pinguins para Novos Usuarios...");
		sprintf(mess,"%s ALLOWED new users\n",ustr[user].name);
		write_syslog(mess,1); allow_new=1;  break;
	case 35: version(user); break; 
	case 36: enter_pro(user,inpstr);  break;
	case 37: exa_pro(user,inpstr);  break;
        case 38: change_pass(user,inpstr); break;
        case 39: dmail(user,inpstr);  break;
	case 40: rmail(user);  break;
	case 41: smail(user,inpstr);  break;
	case 42: wake(user,inpstr);  break;
	case 43: promote(user,inpstr);  break;
	case 44: cls(user); break;
        case 45: addbug(user,inpstr); break;
        case 46: delbug(user,inpstr); break;
        case 47: vbug(user); break;
        case 48: suggest(user,inpstr); break; 
        case 49: dsuggest(user,inpstr); break; 
        case 50: vsug(user); break;        
        case 51: talkers(user); break;
        case 52: rules(user); break;
        case 53: sayto(user,inpstr); break;
	case 54: uptime(user); break;
        default: write_user(user,"O que?"); break;
	}
}



/*** closes socket & does relevant output to other users & files ***/
user_quit(user)
int user;
{   
int area=ustr[user].area;
char filename[30];
   
/* see is user has quit befor he logged in */
if (ustr[user].logging_in) {
	close(ustr[user].sock);
	ustr[user].logging_in=0;
	ustr[user].sock=-1;
	ustr[user].area=-1;
	return;
	}
/* save stats */
if (!save_stats(user)) {
	sprintf(mess,"%s : Nao consegui gravar a sua informacao...\n\r",syserror);
	write_user(user,mess);
	sprintf(mess,"ERROR: Couldn't save %s's stats in user_quit()\n",ustr[user].name);
	write_syslog(mess,0);
	}

sprintf(filename,"%s/%s",SCREENSDIR,TALKERS);
sprintf(mess,"\n\r=> Saindo do %s ... \n\r=> Se voce gostou deste talker, visite tambem ... \n\r",TALKERNAME);   
write_user(user,mess); 
more(user,ustr[user].sock,filename);
close(ustr[user].sock);

/* send message to other users & conv file  & reset some vars */
if (ustr[user].name[0]!='?') {
	sprintf(mess,"=> [ SAIU ]: %s %s\n\r",ustr[user].name,ustr[user].desc);
	write_alluser(user,mess,1,0);
        sprintf(mess,"%s saiu do %s \n\r",ustr[user].name,TALKERNAME);
	write_syslog(mess,1);
	}
if (astr[area].private && astr[area].status!=2 && find_num_in_area(area)<=PRINUM) {
	write_alluser(user,"Sala voltou a ser publica\n\r",0,0);
	astr[area].private=0;
	}
num_of_users--;
ustr[user].area=-1;
ustr[user].sock=-1;
ustr[user].logging_in=0;
ustr[user].name[0]=0;
if (ustr[user].pro_enter) free(ustr[user].pro_start);
whowrite();
counting_user(1);   
}



/*** Displays who's on ***/
who(user,people)
int user,people;
{
int u,tm,idle,min,invis=0;
char *yesno[]={ "NO","YES" };
char *levstr[]={ "EMBRIAO","OVO","PINGUIM","TUX" };
char timestr[30],temp[80];

/* display current time */
time((long *)&tm);
strcpy(timestr,ctime((long *)&tm));
timestr[strlen(timestr)-1]=0;
sprintf(mess,"\n\r*** Pinguins conectados atualmente %s ***\n\n\r",timestr);
write_user(user,mess);

/* display user list */
for (u=0;u<MAX_USERS;++u) {
	if (ustr[u].area!=-1)  {
		if (!ustr[u].vis && ustr[user].level<ustr[u].level && ustr[u].level>USER)  { invis++;  continue; }
		min=(tm-ustr[u].time)/60;
		idle=(tm-ustr[u].last_input)/60;
			sprintf(temp,"%s %s",ustr[u].name,ustr[u].desc);
			sprintf(mess,"%-40s : %-9s : %s : %d mins.\n\r",temp,levstr[ustr[u].level],astr[ustr[u].area].name,min);
		write_user(user,mess);
		}
	if (ustr[u].area==-1 && ustr[u].logging_in && people) {
		sprintf(mess,"LOGIN de %s na linha %d\n\r",ustr[u].site,ustr[u].sock);	
		write_user(user,mess);
		}
	}
if (invis) {
	sprintf(mess,"\n\rExistem %d pinguins invisiveis aos seus olhos...",invis);
	write_user(user,mess);
	}
sprintf(mess,"\n\rTotal de %d pinguins ligados\n\r",num_of_users);
write_user(user,mess);
}



/*** shout sends speech to all users regardless of area ***/
shout(user,inpstr)
int user;
char *inpstr;
{
if (!inpstr[0]) {
	write_user(user,"Grite, mas pelo menos fale algo. O que voce quer gritar?");  return;
	}
sprintf(mess,"%s grita: %s\n\r",ustr[user].name,inpstr);
if (!ustr[user].vis)
	sprintf(mess,"Um pinguim grita: %s\n\r",inpstr);
write_alluser(user,mess,1,0);
sprintf(mess,"Voce grita: %s",inpstr);
write_user(user,mess);
}



/*** tells another user something without anyone else hearing ***/
tell(user,inpstr)
int user;
char *inpstr;
{
char other_user[ARR_SIZE],name[ARR_SIZE];
int user2,temp;
   
sscanf(inpstr,"%s ",other_user);
other_user[0]=toupper(other_user[0]);
inpstr=remove_first(inpstr);
if (!inpstr[0]) {  
	write_user(user,"Utilizacao: .tell <animal> <mensagem>");  return;
	}
if ((user2=get_user_num(other_user))==-1) {
	sprintf(mess,"%s nao esta' no Mundo dos Pinguins!",other_user);
	write_user(user,mess);  return;
	}
if (user2==user) {
	write_user(user,"Isto nao eh um hospicio, se quer falar consigo mesmo, esta no local errado ... procure a clinica de reabilitacao mais proxima e deixe de usar drogas!");
	return;
	}

if (!ustr[user2].listen)  {
	sprintf(mess,"%s nao esta ouvindo...",other_user);
	write_user(user,mess);
	return;
	}
if (ustr[user].vis) strcpy(name,ustr[user].name);
else strcpy(name,"Um pinguim");
switch(inpstr[strlen(inpstr)-1]) {
	case '?':
		sprintf(mess,"Voce pergunta a %s: %s",ustr[user2].name,inpstr);
		write_user(user,mess);
		sprintf(mess,"%s pergunta para voce: %s\n\r",name,inpstr);
		write_user(user2,mess);   break;
	case '!':
		sprintf(mess,"Voce exclama para %s: %s",ustr[user2].name,inpstr);
		write_user(user,mess);
		sprintf(mess,"%s exclama para voce: %s\n\r",name,inpstr);
		write_user(user2,mess);   break; 
	default:
		sprintf(mess,"Voce diz a %s: %s",ustr[user2].name,inpstr);
		write_user(user,mess);
		sprintf(mess,"%s diz a voce: %s\n\r",name,inpstr);
		write_user(user2,mess);
	}
if (ustr[user].vis && ustr[user2].vis && ustr[user].area==ustr[user2].area) {
	sprintf(mess,"%s sussurra algo a %s...\n\r",name,ustr[user2].name);
	temp=ustr[user2].area;
	ustr[user2].area=-1;
	write_alluser(user,mess,0,0);
	ustr[user2].area=temp;
	}
}

/*** say something to another user ***/

sayto(user,inpstr)
int user;
char *inpstr;
{
   char other_user[ARR_SIZE], type[10], tmp_user[ARR_SIZE];
   int user2;
   DIR *dir;
   struct dirent *dp;
   
   sscanf(inpstr,"%s ",other_user);
   other_user[0]=toupper(other_user[0]);
   inpstr=remove_first(inpstr);
   
   sprintf(tmp_user,"%s.D",other_user);
   
   if (!inpstr[0]) {
	write_user(user,"Uso: .sayto <user> <mensagem>");  return; 
	}
   
   if ((user2=get_user_num(other_user))==-1) 
     {
	if((dir=opendir(USERDATADIR))==NULL)
	  {
	     sprintf(mess,"=> %s nao esta no talker",other_user);
	     write_user(user,mess);  
	     sprintf(mess,"GAWNUTS : erro ao abrir diretorio para a funcao sayto %s\n",USERDATADIR);
	     write_syslog(mess,1);
	     return;
	  }
	else
	  {
	     while(dp=readdir(dir))
	       {
		  if(!strcmp(dp->d_name,".") || !strcmp(dp->d_name,"..") || !strcmp(dp->d_name,".D")) continue;
		  if(strstr(dp->d_name,tmp_user))
		    { 
		       sprintf(mess,"=> %s nao esta no talker",other_user);
		       write_user(user,mess);
		       (void)closedir(dir);
		       return;
		    }
	       }
	     (void)closedir(dir);
	     sprintf(mess,"=> Nao ha nenhum usuario cadastrado com o nome %s",other_user);
	     write_user(user,mess);
	     return;
	  }
     }
   
      
   if (user2==user) 
     {
        sprintf(mess,"\n\r=> %s, porque voce acaba de tentar comecar um monologo ?",ustr[user].name);
        write_user(user,mess);
	return;
     }
  
   
   if((ustr[user2].vis) && ( ustr[user2].area == ustr[user].area))
     {
	switch(inpstr[strlen(inpstr)-1]) 
	  {
	   case '?': strcpy(type,"pergunta");  break;
	   case '!': strcpy(type,"exclama");  break;
	   case ')': strcpy(type,"sorri"); break;
	   default : strcpy(type,"diz");
	  }
	
	sprintf(mess,"-> Voce %s para (%s) : %s",type,ustr[user2].name,inpstr);
	write_user(user,mess);
	sprintf(mess,"-> %s %s para (%s) : %s \n\r",ustr[user].name,type,ustr[user2].name,inpstr);
	write_alluser(user,mess,ustr[user].area,0);
     }
   else
     {
	sprintf(mess,"=> %s, no momento eh impossivel falar com este usuario \n\r",ustr[user].name);
	write_user(user,mess);
     }
  
}


/*** look decribes the surrounding scene **/
look(user)
int user;
{
int f,u,area,occupied=0;
char filename[80];

area=ustr[user].area;
sprintf(mess,"\n\rLocal: %s\n\n\r",astr[area].name);
write_user(user,mess);

/* open and read area description file */
sprintf(filename,"%s/%s",DATADIR,astr[area].name);
more(user,ustr[user].sock,filename);

/* show exits from area */
write_user(user,"\n\rSaidas:  ");
for (f=0;f<strlen(astr[area].move);++f) {
	write_user(user,astr[astr[area].move[f]-65].name);
	write_user(user,"  ");
	}
	
write_user(user,"\n\n\r");
for (u=0;u<MAX_USERS;++u) {
	if (ustr[u].area!=area || u==user || !ustr[u].vis) continue;
	if (!occupied) write_user(user,"Pinguins neste local:\n\r");
	sprintf(mess,"	 %s %s\n\r",ustr[u].name,ustr[u].desc);
	write_user(user,mess);
	occupied++;	
	}
if (!occupied) write_user(user,"Nao ha nenhum pinguim neste local ...\n\r");
write_user(user,"\n\rEste local esta' ");
if (astr[ustr[user].area].private) write_user(user,"privado\n\r");
	else write_user(user,"publico\n\r");
sprintf(mess,"Existem %d mensagens no quadro.\n\r",astr[area].mess_num);
write_user(user,mess);
if (!strlen(astr[area].topic)) 
	write_user(user,"Este local nao tem nenhum topico...");
else {
	sprintf(mess,"Topico atual: %s",astr[area].topic);
	write_user(user,mess);
	}
}



/*** go moves user into different area ***/
go(user,inpstr,user_letin)
int user,user_letin;
char *inpstr;
{
int f,new_area,teleport=0;
int area=ustr[user].area;
char area_char,area_name[ARR_SIZE];
char entmess[30];

if (!inpstr[0]) {
	if (user_letin) write_user(user,"Utilizacao: .letmein <local>");
		else write_user(user,"Utilizacao: .go <local>");
	return;
	}
sscanf(inpstr,"%s ",area_name);

/* see if area exists */
for (new_area=0;new_area<NUM_AREAS;++new_area) 
	if (!instr(astr[new_area].name,area_name)) goto AREA_EXISTS;
	
write_user(user,"Esse local nao existe!");
return;

AREA_EXISTS:
if (ustr[user].area==new_area) {
	write_user(user,"Voce ja esta neste local!!!");  return;
	}
/* see if user can get to area from current area */
area_char=new_area+65;  /* get char. repr. of area to move to (A-I) */

/* see if new area is joined to current one */
strcpy(entmess,"entra.");
for (f=0;f<strlen(astr[area].move);++f) 
	if (astr[area].move[f]==area_char)  goto JOINED;

if (ustr[user].level>USER) {
	strcpy(entmess,"surge neste recinto!");  
	teleport=1;  goto JOINED;
	}
write_user(user,"Esse local nao esta ligado a esse ...");
return;

JOINED:
if (user_letin) {
	letmein(user,new_area);  return;
	}
if (astr[new_area].private && ustr[user].invite!=new_area && ustr[user].level<WIZARD) {
	write_user(user,"Desculpe, mas este local atualmente e privado...");
	return;
	}

/* output to old area */
if (teleport && ustr[user].vis) { 
	sprintf(mess,"=> %s desaparece magicamente!\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
	}
if (!teleport && ustr[user].vis) {
	sprintf(mess,"=> %s foi para um local de nome %s\n\r",ustr[user].name,astr[new_area].name);
	write_alluser(user,mess,0,0);
	}
/* gods dont show any entry message, wizards show this */
if (!ustr[user].vis && ustr[user].level==WIZARD) {
	write_alluser(user,"Voce sente algo magico, passando bem proximo...\n\r",0,0);
	}
if (astr[area].private && astr[area].status!=2 && find_num_in_area(area)<=PRINUM) {
	write_alluser(user,"Local passou a ser outra vez publico.\n\r",0,0);
	astr[area].private=0;
	}


/* send output to new area */
ustr[user].area=new_area;
if (!ustr[user].vis) {
	if (ustr[user].level==WIZARD) 
		write_alluser(user,"Voce sente algo magico, passando bem proximo...\n\r",0,0);
	}
else {
	sprintf(mess,"=> %s %s\n\r",ustr[user].name,entmess);
	write_alluser(user,mess,0,0);
	}

/* deal with user */
if (ustr[user].invite==new_area)  ustr[user].invite=-1;
look(user);
}



/*** Subsid func of go ***/
letmein(user,new_area)
int user,new_area;
{
char name[ARR_SIZE];

if (!astr[new_area].private) {
	write_user(user,"=> Este local ja era publico, de um modo ou de outro...");
	return;
	}
sprintf(mess,"=> Grita desesperadamente para todos os lados  %s pedindo para entrar!",astr[new_area].name);
write_user(user,mess);
sprintf(mess,"=> %s esta gritando, pedindo para entrar!\n\r",ustr[user].name);
if (!ustr[user].vis) sprintf(mess,"=> Um pinguim esta gritando, pedindo para entrar!\n\r");
write_area(new_area,mess);

/* send message to users in current area */
if (!ustr[user].vis) strcpy(name,"Um pinguim");
else strcpy(name,ustr[user].name);
sprintf(mess,"=> %s grita para o local %s pedindo para entrar!\n\r",name,astr[new_area].name);
write_alluser(user,mess,0,0);
}



/*** area_access sets area to private or public ***/
area_access(user,priv)
int user,priv;
{
int area;
char *noset="Nada disso, aqui voce nao pode mexer...";
char *pripub[]={ "public","private" };

area=ustr[user].area;

/* see if areas access can be set */
if (astr[area].status) {
	write_user(user,noset);  return;
	}

/* see if access already set to user request */
if (priv==astr[area].private) {
	sprintf(mess,"=> Esse local ja eh %s!",pripub[priv]);
	write_user(user,mess);  return;
	}
// oia aqui
/* set to public */
if (!priv) {
	write_user(user,"=> Local passa a ser publico.");
	sprintf(mess,"=> %s colocou este lugar publico...\n\r",ustr[user].name);
	if (!ustr[user].vis) 
		sprintf(mess,"=> Alguem fez com que este local fosse publico...\n\r");
	write_alluser(user,mess,0,0);
	astr[area].private=0;
	return;
	}

/* need at least PRINUM people to set area to private unless are superuser */
if (find_num_in_area(area)<PRINUM && ustr[user].level<WIZARD) {
	sprintf(mess,"=> Voce precisa de pelo menos de %d pessoas para isso...",PRINUM);
	write_user(user,mess);
	return;
	};
write_user(user,"=> Pronto, este ja eh um local privado.");
sprintf(mess,"=> %s fez com que este fosse um lugar privado.\n\r",ustr[user].name);
if (!ustr[user].vis)
	sprintf(mess,"=> Um usuario fez com que este local fosse um lugar privado.\n\r");
write_alluser(user,mess,0,0);
astr[area].private=1;
}



/*** invite someone into private area ***/
invite_user(user,inpstr)
int user;
char *inpstr;
{
int u,area=ustr[user].area;
char other_user[ARR_SIZE];

if (!inpstr[0]) {
	write_user(user,"Uso: .invite <animal>");  return;
	}
if (!astr[area].private) {
	write_user(user,"Esta area e' publica!");  return;
	}
sscanf(inpstr,"%s ",other_user);
other_user[0]=toupper(other_user[0]);

/* see if other user exists */
if ((u=get_user_num(other_user))==-1) {
	sprintf(mess,"%s nem sequer esta' na Selva...",other_user);
	write_user(user,mess);  return;
	}

if (!strcmp(other_user,ustr[user].name)) {
	write_user(user,"=> Ei seu doido, para que convidar voce mesmo para algum lugar ? Mania de monologo ?...");  return;
	}
if (ustr[u].area==ustr[user].area) {
	sprintf(mess,"Mas... %s ja esta aqui!",ustr[u].name);
	write_user(user,mess);
	return;
	}
write_user(user,"OK! ");
if (!ustr[user].vis) 
	sprintf(mess,"=> Voce foi convidado para %s\n\r",astr[area].name);
else sprintf(mess,"=> %s convidou voce para %s\n\r",ustr[user].name,astr[area].name);
write_user(u,mess);
ustr[u].invite=area;
}



/*** emote func used for expressing emotional or visual stuff ***/
emote(user,inpstr)
int user;
char *inpstr;
{
if (!inpstr[0]) {
	write_user(user,"Uso: .emote <texto>");  return;
	}
if (!ustr[user].vis) sprintf(mess,"Um animal %s",inpstr);
else sprintf(mess,"%s %s",ustr[user].name,inpstr);

/* write & record output */
write_user(user,mess);
strcat(mess,"\n\r");
write_alluser(user,mess,0,0);
record(mess,ustr[user].area);
}



// clear the screen with terminal flush 

cls(user)
int user;
{
   
   strcpy(mess,"\e[2J");
   
   write_user(user,mess);

}


/*** Gives current status of areas */
areas(user)
int user;
{
int area;
char *pripub[]={ "publico","privado" };
char *yesno[]={ "NAO","SIM" };

write_user(user,"\n\rLocal            : Pri/Pub Fixo  Anim Msgs     Topico\n\n\r");
for (area=0;area<NUM_AREAS;++area) {
	sprintf(mess,"%-15s  : %-7s   %3s   %2d  %3d   ",astr[area].name,pripub[astr[area].private],yesno[(astr[area].status>0)],find_num_in_area(area),astr[area].mess_num);
	if (!strlen(astr[area].topic)) strcat(mess,"<sem topico>");
	else strcat(mess,astr[area].topic);
	strcat(mess,"\n\r");
	mess[0]=toupper(mess[0]);
	write_user(user,mess);
	}

sprintf(mess,"\n\rUm total de %d locais.\n\r",NUM_AREAS);
write_user(user,mess);
}



/*** save message to area message board file ***/
write_board(user,inpstr)
int user;
char *inpstr;
{
FILE *fp;
char filename[30],name[NAME_LEN];

if (!inpstr[0]) {
	write_user(user,"Uso: .write <mensagem>"); return;
	}

/* open board file */
sprintf(filename,"%s/board%d",MESSDIR,ustr[user].area);
if (!(fp=fopen(filename,"a"))) {
	sprintf(mess,"=> %s : mensagem nao pode ser escrita.",syserror);
	write_user(user,mess);
	sprintf(mess,"ERROR: Couldn't open %s message board file to write in write_board()\n",astr[ustr[user].area].name);
	write_syslog(mess,0);
	return;
	}

/* write message - alter nums. in midcpy to suit */
strcpy(name,ustr[user].name);
if (!ustr[user].vis)  strcpy(name,"Um animal");
sprintf(mess,"(%s) De %s: %s\n",timeline(0),name,inpstr);
fputs(mess,fp);
fclose(fp);

/* send output */
write_user(user,"=> Voce escreves uma mensagem no quadro!");
sprintf(mess,"=> %s escreve uma mensagem no quadro.\n\r",ustr[user].name);
if (!ustr[user].vis) 
	sprintf(mess,"=> Wow, voce acaba de ver uma mao fantasma a escrever uma mensagem no quadro - spooky...\n\r");
write_alluser(user,mess,0,0);
astr[ustr[user].area].mess_num++;
}



/*** read the message board ***/
read_board(user)
int user;
{
char filename[30];

/* send output to user */
sprintf(filename,"%s/board%d",MESSDIR,ustr[user].area);
sprintf(mess,"\n\r*** O quadro da %s ***\n\n\r",astr[ustr[user].area].name);
write_user(user,mess);

if (!more(user,ustr[user].sock,filename) || !astr[ustr[user].area].mess_num) 
	write_user(user,"Nao existem mensagens no quadro.\n\r");

/* send output to others */
sprintf(mess,"=> %s le o quadro.\n\r",ustr[user].name);
if (ustr[user].vis) write_alluser(user,mess,0,0);
}



/*** wipe board (erase file) ***/
wipe_board(user,inpstr)
int user;
char *inpstr;
{
int lines,cnt=0;
char c,filename[20],temp[20];
char *nocando="Nao consigo apagar tanta coisa...";
FILE *bfp,*tfp;

lines=atoi(inpstr);
if (lines<1) {
	write_user(user,"Uso: .wipe <numero de comentarios a apagar>");  return;
	}
sprintf(filename,"%s/board%d",MESSDIR,ustr[user].area);
if (!(bfp=fopen(filename,"r"))) {
	write_user(user,nocando);  return;
	}
sprintf(temp,"%s/temp",MESSDIR);
if (!(tfp=fopen(temp,"w"))) {
	write_user(user,"=> Oops ... desculpe mas o talker esta' com dificuldades em fazer isso...");
	write_syslog("ERROR: Couldn't open temporary file to write in wipe_board()\n",0);
	fclose(bfp);
	return;
	}

/* find start of where to copy */
while(cnt<lines) {
	c=getc(bfp);
	if (feof(bfp)) {
		write_user(user,nocando);
		fclose(bfp);  fclose(tfp);
		return;
		}
	if (c=='\n') cnt++;
	}

/* copy rest of board file into temp file & erase board file */
c=getc(bfp);
while(!feof(bfp)) {  putc(c,tfp);  c=getc(bfp); } 
fclose(bfp);  fclose(tfp);
unlink(filename);

/* rename temp file to new board file */
if (rename(temp,filename)==-1) {
	write_user(user,"=> Oops, desculpe mas o talker esta' com dificuldades em fazer isso...");
	write_syslog("ERROR: Couldn't rename temp file to board file in wipe_board()\n",0);
	astr[ustr[user].area].mess_num=0;
	return;
	}
astr[ustr[user].area].mess_num-=lines;

/* print messages */
write_user(user,"Ok");
sprintf(mess,"=> %s apaga algumas mensagens da board.\n\r",ustr[user].name);
if (!ustr[user].vis)
	sprintf(mess,"Uma mao fantasma apaga uma mensagem do quadro... SPOOKY!\n\r");
write_alluser(user,mess,0,0);
}


// adiciona um bug 

addbug(user,inpstr)
int user;
char *inpstr;
{
FILE *fp;
char filename[30],name[NAME_LEN];

if (!inpstr[0]) {
	write_user(user,"Uso: .bugtrack <bug a ser informado>"); return;
	}

/* open board file */
sprintf(filename,"%s/%s",DATADIR,BUGFILE);
if (!(fp=fopen(filename,"a"))) {
	sprintf(mess,"%s : bug nao pode ser adicionado, mande um smail para o Ironwood.",syserror);
	write_user(user,mess);
	sprintf(mess,"ERROR: Couldn't open %s message board file to write in write_board()\n",astr[ustr[user].area].name);
	write_syslog(mess,0);
	return;
	}

/* write message - alter nums. in midcpy to suit */

strcpy(name,ustr[user].name);
if (!ustr[user].vis)  strcpy(name,"Um pinguim");
sprintf(mess,"(%s) De %s: %s\n",timeline(0),name,inpstr);
fputs(mess,fp);
fclose(fp);

/* send output */
write_user(user,"=> Voce adiciona um bug a nossa bugtrack!");
sprintf(mess,"=> %s adiciona um bug a nossa bug list .\n\r",ustr[user].name);

if (!ustr[user].vis) 
	sprintf(mess,"Visualiza um usuario nervoso a adicionar um bug a nossa bugtrack...\n\r");

write_alluser(user,mess,0,0);

number_of_bugs++;


}

// deleta um bug 

delbug(user,inpstr)
int user;
char *inpstr;
{
int lines,cnt=0;
char c,filename[20],temp[20];
char *nocando="Nao consigo apagar tanta coisa...";
FILE *bfp,*tfp;

lines=atoi(inpstr);
if (lines<1) {
	write_user(user,"Uso: .dbug <numero de bugs a apagar >");  return;
	}
	
sprintf(filename,"%s/%s",DATADIR,BUGFILE);
if (!(bfp=fopen(filename,"r"))) {
	write_user(user,nocando);  return;
	}
	
sprintf(temp,"%s/temp",MESSDIR);
if (!(tfp=fopen(temp,"w"))) {
	write_user(user,"Ichi, de uma olhada em sua programacao, ha algum defeito eminente aqui...");
	write_syslog("ERROR: Couldn't open temporary file to write in wipe_board()\n",0);
	fclose(bfp);
	return;
	}

/* find start of where to copy */
while(cnt<lines) {
	c=getc(bfp);
	if (feof(bfp)) {
		write_user(user,nocando);
		fclose(bfp);  fclose(tfp);
		return;
		}
	if (c=='\n') cnt++;
	}

/* copy rest of board file into temp file & erase board file */
c=getc(bfp);
while(!feof(bfp)) {  putc(c,tfp);  c=getc(bfp); } 
fclose(bfp);  fclose(tfp);
unlink(filename);

/* rename temp file to new board file */
if (rename(temp,filename)==-1) {
	write_user(user,"Ei, olhe a sua programacao, realmente ha algum defeito eminente aqui...");
	write_syslog("ERROR: Couldn't rename temp file to board file in wipe_board()\n",0);
	number_of_bugs=0;
	return;
	}
	
number_of_bugs=number_of_bugs - lines;

/* print messages */
write_user(user,"Ok");

}

// le os bugs constantes na bug list 

vbug (user)
int user;
{
char filename[30];

sprintf(filename,"%s/%s",DATADIR,BUGFILE);
sprintf(mess,"\n\r*** Lista de BUGS DO %s ***\n\rTemos atualmente %d bugs adicionados\n\n\r",TALKERNAME,number_of_bugs);
write_user(user,mess);

more(user,ustr[user].sock,filename);


}

// insere uma sugestao no talker 

suggest(user,inpstr)
int user;
char *inpstr;
{
FILE *fp;
char filename[30],name[NAME_LEN];

if (!inpstr[0]) {
	write_user(user,"Uso: .suggest <sugestao>"); return;
	}

/* open board file */
sprintf(filename,"%s/%s",DATADIR,SUGESTFILE);
if (!(fp=fopen(filename,"a"))) {
	sprintf(mess,"%s : sugestao nao pode ser adicionada, mande um smail para o Ironwood.",syserror);
	write_user(user,mess);
	sprintf(mess,"ERROR: Couldn't open %s message board file to write in write_board()\n",astr[ustr[user].area].name);
	write_syslog(mess,0);
	return;
	}

/* write message - alter nums. in midcpy to suit */

strcpy(name,ustr[user].name);
if (!ustr[user].vis)  strcpy(name,"Um pinguim");
sprintf(mess,"(%s) De %s: %s\n",timeline(0),name,inpstr);
fputs(mess,fp);
fclose(fp);

/* send output */
write_user(user,"=> Voce adicionou uma sugestao, em breve ela sera implementada!");
sprintf(mess,"=> %s adicionou uma sugestao .\n\r",ustr[user].name);

if (!ustr[user].vis) 
	sprintf(mess,"=> Um usuario criativo acaba de adicionar uma sugestao, e os GODS irao analisar a sua implementacao...\n\r");

write_alluser(user,mess,0,0);

number_of_sugests++;


}

// visualiza as sugestoes no talker 

dsuggest(user,inpstr)
int user;
char *inpstr;
{
int lines,cnt=0;
char c,filename[20],temp[20];
char *nocando="Nao consigo apagar tanta coisa...";
FILE *bfp,*tfp;

lines=atoi(inpstr);
if (lines<1) {
	write_user(user,"Uso: .dsuggest <numero de sugestoes a apagar >");  return;
	}
	
sprintf(filename,"%s/%s",DATADIR,SUGESTFILE);
if (!(bfp=fopen(filename,"r"))) {
	write_user(user,nocando);  return;
	}
	
sprintf(temp,"%s/temp",MESSDIR);
if (!(tfp=fopen(temp,"w"))) {
	write_user(user,"Ichi, de uma olhada em sua programacao, ha algum defeito eminente aqui...");
	write_syslog("ERROR: Couldn't open temporary file to write in wipe_board()\n",0);
	fclose(bfp);
	return;
	}

/* find start of where to copy */
while(cnt<lines) {
	c=getc(bfp);
	if (feof(bfp)) {
		write_user(user,nocando);
		fclose(bfp);  fclose(tfp);
		return;
		}
	if (c=='\n') cnt++;
	}

/* copy rest of board file into temp file & erase board file */
c=getc(bfp);
while(!feof(bfp)) {  putc(c,tfp);  c=getc(bfp); } 
fclose(bfp);  fclose(tfp);
unlink(filename);

/* rename temp file to new board file */
if (rename(temp,filename)==-1) {
	write_user(user,"=> Ei, olhe a sua programacao, realmente ha algum defeito eminente aqui...");
	write_syslog("ERROR: Couldn't rename temp file to board file in wipe_board()\n",0);
	number_of_bugs=0;
	return;
	}
	
number_of_sugests=number_of_sugests - lines;

/* print messages */
write_user(user,"Ok");

}

// le os bugs constantes na bug list 

vsug (user)
int user;
{
char filename[30];

sprintf(filename,"%s/%s",DATADIR,SUGESTFILE);
sprintf(mess,"\n\r*** Lista de SUGESTOES DO %s ***\n\rTemos atualmente %d sugestoes adicionados\n\n\r",TALKERNAME,number_of_sugests);
write_user(user,mess);

more(user,ustr[user].sock,filename);

}

// view the talkers file 
talkers (user)
int user;
{
char filename[30];

sprintf(filename,"%s/%s",SCREENSDIR,TALKERS);
sprintf(mess,"\n\r=>  Talkers amigos do %s <= \n\n\r",TALKERNAME);
write_user(user,mess);

more(user,ustr[user].sock,filename);
     
}

/* version command */

version(user)
int user;
{
char filename[30];

sprintf(filename,"%s/%s",SCREENSDIR,VERSIONFILE);
more(user,ustr[user].sock,filename);

}

/* show the rules of the talker */

rules(user)
int user;
{
   char filename[30];
   
   sprintf(filename,"%s/%s",SCREENSDIR,RULESFILE);
   more(user,ustr[user].sock,filename);

}

/* show for new user, thing about the talker */

what_is_this(user)
int user;
{
   char filename[30];
   sprintf(filename,"%s/%s",SCREENSDIR,WHATISTHISFILE);
   more(user,ustr[user].sock,filename);
}


/*** sets area topic ***/
set_topic(user,inpstr)
int user;
char *inpstr;
{
if (!inpstr[0]) {
	if (!strlen(astr[ustr[user].area].topic)) {
		write_user(user,"Caramba, voce esta louco ? Aqui nao ha nenhum topico!");  return;
		}
	else {
		sprintf(mess,"O topico atual eh: %s",astr[ustr[user].area].topic);
		write_user(user,mess);  return;
		}
	}
if (strlen(inpstr)>TOPIC_LEN) {
	write_user(user,"Nao exagere, este topico esta grande demais...");  return;
	}

strcpy(astr[ustr[user].area].topic,inpstr);

/* send output to users */
sprintf(mess,"Pronto, o topico passou a ser %s",inpstr);
write_user(user,mess);
sprintf(mess,"%s mudou o topico para %s\n\r",ustr[user].name,inpstr);
if (!ustr[user].vis)
	sprintf(mess,"Um pinguim mudou o topico para %s\n\r",inpstr);
write_alluser(user,mess,0,0);
}



/*** sets superuser to visible or invisible ***/
visible(user,vis)
int user,vis;
{
if (ustr[user].vis && vis) {
	write_user(user,"=> Voce ja esta visivel!");  return;
	}
if (!ustr[user].vis && !vis) {
	write_user(user,"=> Voce ja esta invisivel!");  return;
	}

ustr[user].vis=vis;
if (vis) {
	write_user(user,"=> POP! Voce voltou a ficar visivel!");
	sprintf(mess,"=> BOO! %s aparece do nada ao seu lado!\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
	}
else   { 
	write_user(user,"=> Um ritual antigo ecoa, e voce desaparece...");
	sprintf(mess,"=> %s desaparece ao som de um antigo ritual...\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
	}
}



/*** Throw off an annoying bastard (or throw off someone for a laugh) ***/
kill_user(user,inpstr)
int user;
char *inpstr;
{
char name[ARR_SIZE];
int victim;

if (!inpstr[0]) {
	write_user(user,"Uso: .kill <animal>");  return;
	}
sscanf(inpstr,"%s ",name);
name[0]=toupper(name[0]);
if ((victim=get_user_num(name))==-1) {
	sprintf(mess,"=> %s nao esta' conectado ao talker neste momento!",name);
	write_user(user,mess);  return;
	}
if (victim==user) {
	write_user(user,"=> ? Porque voce esta querendo cometer suicidio ?");
	return;
	}

/* can't kill god */
if (ustr[victim].level==GOD) {
	write_user(user,"=> Oops ... O QUE VOCE PRETENDE TENTANDO MATAR UM DEUS ?");
	sprintf(mess,"=> %s enlouqueceu: tentou lhe matar!\n\r",ustr[user].name);
	write_user(victim,mess);
	return;
	}

/* record killing */
sprintf(mess,"=> %s MATOU %s!\n\r",ustr[user].name,ustr[victim].name);
write_syslog(mess,1);

/* kill user */
sprintf(mess,"=> Um monitor cai em cima da cabeca de %s, e ele MORRE!!\n\r",ustr[victim].name);
write_alluser(victim,mess,0,0);
write_user(victim,"Olhas para o ceu e ve algo a cair... Sera' um piano? sera' um monitor?\n\rVoce nao tem tempo de descobrir. O super-homem eh que nao era...\n\r");
user_quit(victim);
write_area(-1,".oO( Menos um PC com Windows... )Oo.\n\r");
write_user(user,"=> Uhuuuu ...espirito mau! ;)");
}



/*** shutdown talk server ***/
shutdown_talker(user,ls)
int user,ls;
{
int u;
char name[NAME_LEN];

if (shutd==-1) {
	write_user(user,"\n\rTem certeza disso? (y/n)? ");
	shutd=user; noprompt=1;
	return;
	}

write_user(user,"=> A aniquilar todas as possibilidades de sobrevivencia ...\n\r");
for (u=0;u<MAX_USERS;++u) {
	if (ustr[u].area==-1 || u==user) continue;
	write_user(u,"\n\r*** Selva a auto-destruir-se! ***\n\r");
	user_quit(u);
	}

write_user(user,"\n\r=> Adeusinho, voltamos em breve...\n\r");
strcpy(name,ustr[user].name);
user_quit(user);
sprintf(mess,"*** Talker SHUTDOWN by %s on %s ***\n",name,timeline(1));
write_syslog(mess,0);

/* close listen socket */
close(ls);
exit(0); 
}



/*** search for specific word in the message files ***/
search(user,inpstr)
int user;
char *inpstr;
{
int b,occured=0;
char word[ARR_SIZE],filename[20],line[ARR_SIZE];
FILE *fp;

if (!inpstr[0]) {
	write_user(user,"Uso: .search <palavra(s)>");  return;
	}
sscanf(inpstr,"%s ",word);

/* look through boards */
for (b=0;b<NUM_AREAS;++b) {
	sprintf(filename,"%s/board%d",MESSDIR,b);
	if (!(fp=fopen(filename,"r"))) continue;
	fgets(line,300,fp);
	while(!feof(fp)) {
		if (instr(line,word)==-1) {
			fgets(line,300,fp);  continue;
			}
		sprintf(mess,"%s : %s\r",astr[b].name,line);
		mess[0]=toupper(mess[0]);
		write_user(user,mess);	
		++occured;
		fgets(line,300,fp);
		}
	fclose(fp);
	}
if (!occured) write_user(user,"=> Nao foram encontradas ocorrencias...");
else {
	sprintf(mess,"\n\r=> %d ocurrencias encontradas!\n\r",occured);
	write_user(user,mess);
	}
}



/*** review last five lines of conversation in area ***/
review(user)
int user;
{
int area=ustr[user].area;
int pos=astr[area].conv_line%NUM_LINES;
int f;

for (f=0;f<NUM_LINES;++f) {
	write_user(user,conv[area][pos++]);  pos=pos%NUM_LINES;
	}
}



/*** help function ***/
help(user,inpstr)
int user;
char *inpstr;
{
int com,nl=0;
char *levstr[]={ "EMBRIAO","OVO","PINGUIM","TUX" };
char filename[ARR_SIZE],word[ARR_SIZE],word2[ARR_SIZE];

/* help for one command */
if (strlen(inpstr)) {
	sscanf(inpstr,"%s",word);
	sprintf(word2,".%s\n",word);
	if (get_com_num(word2)==-1) {
		write_user(user,"=> Esse comando nao existe!");  return;
		}
	sprintf(filename,"%s/%s",HELPDIR,word);
	if (!more(user,ustr[user].sock,filename)) 
		write_user(user,"=> Desculpe mais ainda nao existe ajuda para esse comando :(");
	return;
	}

/* general help */
sprintf(mess,"\n\r*** Comandos existentes para pinguins do nivel %s ***\n\n\r",levstr[ustr[user].level]);
write_user(user,mess);
com=0;
while(command[com][0]!='*') {
	if (ustr[user].level<com_level[com]) { ++com;  continue; }
	sprintf(mess,".%-10s ",command[com]);  mess[0]=' ';
	write_user(user,mess);
	++nl; ++com;
	if (nl==5) {  write_user(user,"\n\r");  nl=0; }
	}
write_user(user,"\n\rPara saber para que serve um comando faca .help <comando>.\n\r");
}



/*** Broadcast message to everyone without the "X shouts:" bit ***/
broadcast(user,inpstr)
int user;
char *inpstr;
{
if (!inpstr[0]) {
	write_user(user,"Uso: .bcast <mensagem>");  return;
	}
sprintf(mess,"*** %s ***\n\r",inpstr);
write_area(-1,mess);
}




/*** Move user somewhere else ***/
move(user,inpstr)
int user;
char *inpstr;
{
char other_user[ARR_SIZE],area_name[260];
int area,user2;

/* do checks */
sscanf(inpstr,"%s %s",other_user,area_name);
other_user[0]=toupper(other_user[0]);
inpstr=remove_first(inpstr);
if (!inpstr[0]) {
	write_user(user,"Uso: .move <animal> <area>");  return;
	}
if ((user2=get_user_num(other_user))==-1) {
	sprintf(mess,"=> %s nao esta conectado ao talker",other_user);
	write_user(user,mess);  return;
	}

/* see if user is moving himself */
if (user==user2) {
	write_user(user,"=> Oops ... ja nao te satisfaz o .go ? Boa tentativa...");
	return;
	}

/* see if user to be moved is god */
if (ustr[user2].level==GOD) {
	write_user(user,"=> Mover um DEUS... Talvez um dia voce tenha sorte :P");
	sprintf(mess,"=> %s tentou mover voce ... eh um Brincalhao!\n\r",ustr[user].name);
	write_user(user2,mess);
	return;
	}
	
/* check area */
for (area=0;area<NUM_AREAS;++area) 
	if (!strcmp(astr[area].name,area_name)) goto FOUND;	
write_user(user,"=> Vai aonde? Isso nao existe!");
return;

FOUND:  
if (area==ustr[user2].area) {
	sprintf(mess,"%s ja esta perto de voce!!",ustr[user2].name);
	write_user(user,mess);
	return;
	}
	
/** send output **/
write_user(user2,"=> \n\rAlguem pega voce e lhe atira para outro lugar!!!\n\r");

/* to old area */
sprintf(mess,"=> %s e atirado para outro lado!\n\r",ustr[user2].name);
write_alluser(user2,mess,0,0);
if (astr[ustr[user2].area].private && astr[ustr[user2].area].status!=2 && find_num_in_area(ustr[user2].area)<=PRINUM) {
	write_alluser(user2,"Este lugar voltou a ficar publico...\n\r",0,0);
	astr[ustr[user2].area].private=0;
	}
ustr[user2].area=area;
look(user2);
prompt(user2);

/* to new area */
sprintf(mess,"=> %s aparece aqui de repente!\n\r",ustr[user2].name);
write_alluser(user2,mess,0,0);
write_user(user,"Ok");
}



/*** Set system access to allow or disallow further logins ***/
system_access(user,co)
int user,co;
{
if (!co) {
	write_area(-1,"*** O talker esta' agora fechado a novos logins ***\n\r");
	sys_access=0;
	return;
	}
write_area(-1,"*** O talker esta' agora aberto a novos logins ***\n\r");
sys_access=1;
}





/*** Set user description ***/
set_desc(user,inpstr)
int user;
char *inpstr;
{
if (!inpstr[0]) {
	sprintf(mess,"A sua descricao e': %s",ustr[user].desc);
	write_user(user,mess);  return;
	}
if (strlen(inpstr)>=DESC_LEN) {
	write_user(user,"Essa descricao e muito grande!");  return;
	}
strcpy(ustr[user].desc,inpstr);
save_stats(user); 
write_user(user,"=> Foi feito  ;)");
}



/*** Enter profile ***/
enter_pro(user,inpstr)
int user;
char *inpstr;
{
char *c;
int ret_val;

/* get memory */
if (!ustr[user].pro_enter) {
	if (!(ustr[user].pro_start=(char *)malloc(82*PRO_LINES))) {
		write_syslog("ERROR: Couldn't allocate mem. in enter_pro()\n",0);
		sprintf(mess,"=> %s : o talker esta' com problemas de memoria... Avise aos DEUSES!\n\r",syserror);
		write_user(user,mess);  return;
		}
	ustr[user].pro_enter=1;
	ustr[user].pro_end=ustr[user].pro_start;
	sprintf(mess,"%s comeceu a escrever um profile...\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
	sprintf(mess,"\n\r** A escrever o profile **\n\n\rTens um maximo de %d linhas. Escreve um '.' numa linha vazia para saires daqui...\n\n\rLinha 1: ",PRO_LINES);  
	write_user(user,mess);  noprompt=1;  ustr[user].listen=0;
	return;
	}
inpstr[80]=0;  c=inpstr;

/* check for dot terminator */
ret_val=0;
if (*c=='.' && *(c+1)==0) {
	if (ustr[user].pro_enter!=1)  ret_val=write_pro(user);
	if (ret_val) write_user(user,"\n\rProfile gravado\n\r");
	else write_user(user,"\n\rProfile nao gravado\n\r");
	free(ustr[user].pro_start);  ustr[user].pro_enter=0;
	ustr[user].listen=1;
	noprompt=0;  prompt(user); 
	sprintf(mess,"%s acabou de escrever o profile\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
	return;
	}

/* write string to mem */
while(*c) *ustr[user].pro_end++=*c++;
*ustr[user].pro_end++='\n';

/* end of lines */
if (ustr[user].pro_enter==PRO_LINES) {
	ret_val=write_pro(user);  free(ustr[user].pro_start);
	if (ret_val) write_user(user,"\n\rProfile gravado\n\r");
	else write_user(user,"\n\rProfile nao gravado\n\r");
	ustr[user].pro_enter=0; 
	ustr[user].listen=1;
	noprompt=0;  prompt(user);  
	sprintf(mess,"%s acabou de escrever o profile\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
	return;
	}
sprintf(mess,"Linha %d: ",++ustr[user].pro_enter);
write_user(user,mess);
}



/*** Write profile in buffer to file ***/
write_pro(user)
int user;
{
FILE *fp;
char *c,filename[80];

sprintf(filename,"%s/%s.P",USERDATADIR,ustr[user].name);
if (!(fp=fopen(filename,"w"))) {
	sprintf(mess,"ERROR: Couldn't open %s's profile file to write in write_pro()\n",ustr[user].name);
	write_syslog(mess,0);
	sprintf(mess,"%s : nao consigo escrever no arquivo...\n\r",syserror);
	write_user(user,mess);  return 0;
	}
for (c=ustr[user].pro_start;c<ustr[user].pro_end;++c) putc(*c,fp);
fclose(fp);
/* Code for auto promotion: if user is level 0 ... */
if (ustr[user].level==NEWBIE){
	ustr[user].level=USER;
	sprintf(mess,"\n\r=> Parabens, voce foi  promovido a OVO!\n\r");
	write_user(user,mess);
	sprintf(mess,"\n\r=> O %s registou-se e foi promovido a OVO!\n\r",ustr[user].name);
	write_alluser(user,mess,0,0);
}
return 1;
}



/*** show profile ***/
exa_pro(user,inpstr)
int user;
char *inpstr;
{
int u;
char filename[80],user2[20],line[81];
FILE *fp;

if (!inpstr[0]) {
	write_user(user,"Uso: .examine <user>");  return;
	}
sscanf(inpstr,"%s",user2);
user2[0]=toupper(user2[0]);
if (!user_exists(user,user2)) {
	write_user(user,"=> Esse pinguim nao existe");  return;
	}
if ((u=get_user_num(user2))!=-1 && u!=user) {
	sprintf(mess,"=> %s esta lhe examinando...\n\r",ustr[user].name);
	write_user(u,mess);
	}
sprintf(filename,"%s/%s.P",USERDATADIR,user2);
sprintf(mess,"\n\r** Profile do %s **\n\n\r",user2);
write_user(user,mess);
if (!more(user,ustr[user].sock,filename))  write_user(user,"Sem profile.\n\r");
sprintf(filename,"%s/%s.D",USERDATADIR,user2);
if (get_user_num(user2)!=-1) {
	sprintf(mess,"\n\r%s esta ligado no %s!!\n\r",user2,TALKERNAME);
	write_user(user,mess);  return;
	}
if (!(fp=fopen(filename,"r"))) return;
fgets(line,80,fp);
sprintf(mess,"\n\r%s ligou-se pela ultima vez em %s\r",user2,line);
write_user(user,mess);
fclose(fp);
}



/*** Delete mail ***/
dmail(user,inpstr)
int user;
char *inpstr;
{
char c,filename[80];
char *nocando="=> Oops ... voce nao pode apagar isto tudo! Nao abuse ...";
int lines,cnt,any_left;
FILE *fp,*tfp;

lines=atoi(inpstr);
if (lines<1 && strcmp(inpstr,"todas")) {
	write_user(user,"Uso: .dmail <numero de linhas a apagar>/todas");
	return;
	}
sprintf(filename,"%s/%s.M",MAILDIR,ustr[user].name);
if (!(fp=fopen(filename,"r"))) {
	write_user(user,"Voce nao tem nenhum mail para apagar!");
	return;
	}
if (!strcmp(inpstr,"todas")) {
	unlink(filename); 
	write_user(user,"=> Todo o seu mail foi apagado!");
	return;
	}
if (!(tfp=fopen("tempfile","w"))) {
	write_user(user,"=> Desculpe mas nao consegui abrir o arquivo temporario...");
	write_syslog("ERROR: Couldn't open temporary file to write in dmail()\n",0);
	fclose(fp);
	return;
	}

/* go through file */
cnt=0;
while(cnt<lines) {
	c=getc(fp);	
	if (feof(fp)) {
		write_user(user,nocando);
		fclose(fp);  return;
		}
	if (c=='\n') cnt++;
	}

/* copy to temp */
any_left=0;  c=getc(fp);
while(!feof(fp)) {  
	any_left=1;  putc(c,tfp);  c=getc(fp); 
	}
fclose(fp);  fclose(tfp);
unlink(filename);
if (!any_left) {
	sprintf(mess,"Foram apagadas %d linhas de mail",lines);
	write_user(user,mess);
	unlink("tempfile");
	return;
	}

/* rename temp file to new board file */
if (rename("tempfile",filename)==-1) {
	write_user(user,"=> Oops ... houve algum problema aqui ... mande um smail para o Ironwood!");
	write_syslog("ERROR: Couldn't rename temp file to board file in dmail()\n",0);
	return;
	}
sprintf(mess,"Apaguei %d linhas de mail",lines);
write_user(user,mess);
}



/*** Read mail ***/
rmail(user)
int user;
{
FILE *fp;
char filename[80];

// changing the mails and reading mails to database 
// this is made because the users are able to read the emails on a web interface 

sprintf(filename,"%s/%s.M",MAILDIR,ustr[user].name);
if (!(fp=fopen(filename,"r"))) {
	write_user(user,"Voce nao tem mail nenhum!");
	return;
	}
fclose(fp);
write_user(user,"\n\r*** Os seus mails ***\n\n\r");
more(user,ustr[user].sock,filename);
}



/*** Send mail ***/
smail(user,inpstr)
int user;
char *inpstr;
{
char filename[80],name[NAME_LEN],name2[NAME_LEN];
int user2;
FILE *fp;

sscanf(inpstr,"%s ",name);
name[0]=toupper(name[0]);
inpstr=remove_first(inpstr);
if (!inpstr[0]) {
	write_user(user,"Uso: .smail <user> <mensagem>");  return;
	}
if (!strcmp(name,ustr[user].name)) {
	write_user(user,"=> Para que mandar emails para voce mesmo ?");
	return;
	}

/* see if user exists at all .. */
if (!user_exists(user,name)) {
	write_user(user,"=> Esse animal nao existe");  return;
	}
sprintf(filename,"%s/%s.M",MAILDIR,name);
if (!(fp=fopen(filename,"a"))) {
	sprintf(mess,"=> %s : Nao consigo abrir a sua caixa de correio... :(",syserror);
	write_user(user,mess);
	sprintf(mess,"ERROR: Couldn't open %s's mailbox file to append in smail()\n",name);
	write_syslog(mess,0);
	return;
	}

/* send the mail & record mailing */
if (!ustr[user].vis) strcpy(name2,"alguem");
else strcpy(name2,ustr[user].name);
sprintf(mess,"(%s) De %s: %s\n",timeline(0),name2,inpstr);
fputs(mess,fp);
fclose(fp);
write_user(user,"Mail enviado");
sprintf(mess,"%s mailed %s\n",ustr[user].name,name);
write_maillog(mess,1);

/* if recipient is logged on at the moment notify them */
if ((user2=get_user_num(name))!=-1) write_user(user2,"VOCE TEM MAIL NOVO!!!\n\r");
}



/*** Send wakeup message to a user ***/
wake(user,inpstr)
int user;
char *inpstr;
{
int user2;
char name[NAME_LEN];

if (!inpstr[0]) {
	write_user(user,"Uso: .wake <user>");  return;
	}
sscanf(inpstr,"%s",name);
name[0]=toupper(name[0]);
if ((user2=get_user_num(name))==-1) {
	sprintf(mess,"=> %s nao esta conectado ao talker neste momento!",name);
	write_user(user,mess);  return;
	}
if (user==user2) {
	write_user(user,"=> Voce ja esta acordado !!");
	return;
	}
write_user(user2,"*** WAKE UP!! *** ACORDA!! ***\07\07\07\n\r");
write_user(user,"=> Voce ja tentou acorda-lo, sera que houve resultado ?");
}
 


/*** Advance a user a level ***/
promote(user,inpstr)
int user;
char *inpstr;
{
int user2;
char name[NAME_LEN];
char *levstr[]={ "","FOCA","URSO","TUX" };

if (!inpstr[0]) {
	write_user(user,"Uso: .promote <user>");  return;
	}
sscanf(inpstr,"%s",name);
name[0]=toupper(name[0]);
if ((user2=get_user_num(name))==-1) {
	sprintf(mess,"=> %s nao esta conectado ao talker neste momento!",name);
	write_user(user,mess);  return;
	}
if (ustr[user2].level>=ustr[user].level) {
	write_user(user,"=> Voce nao pode promover animais de rank igual ou maior que o seu :P");  return;
	}
ustr[user2].level++;
sprintf(mess,"=> %s promoveu voce a %s!\n\r",ustr[user].name,levstr[ustr[user2].level]);
write_user(user2,mess);
sprintf(mess,"%s PROMOTED %s to %s\n",ustr[user].name,ustr[user2].name,levstr[ustr[user2].level]);
write_syslog(mess,1);
save_stats(user2);
sprintf(mess,"=> %s foi promovido por voce !!!",ustr[user2].name);   
write_user(user,mess);
}



/*** Demote a user ***/
demote(user,inpstr)
int user;
char *inpstr;
{
int user2;
char name[NAME_LEN];

if (!inpstr[0]) {
	write_user(user,"Uso: .demote <user>");  return;
	}
sscanf(inpstr,"%s",name);
name[0]=toupper(name[0]);
if ((user2=get_user_num(name))==-1) {
	sprintf(mess,"=> %s nao esta conectado ao talker neste momento!",name);
	write_user(user,mess);  return;
	}
if (ustr[user2].level<USER || ustr[user2].level>WIZARD) {
	write_user(user,"Ops, veja lah o rank deste animal e tenha certeza se faz realmente sentido despromove-lo...");
	return;
	}
sprintf(mess,"=> %s acabou de despromove-lo!!\n\r",ustr[user].name);
write_user(user2,mess);
sprintf(mess,"%s DEMOTED %s\n",ustr[user].name,ustr[user2].name);
write_syslog(mess,1);
ustr[user2].level--;
save_stats(user2);
write_user(user,"=> Despromovido, esprito mau ;-P");
}



/*** Change users password ***/
change_pass(user,inpstr)
int user;
char *inpstr;
{
char line[81],name[NAME_LEN],passwd[NAME_LEN],word[2][ARR_SIZE];
int found;
FILE *fpi,*fpo;

word[0][0]=0;  word[1][0]=0;
sscanf(inpstr,"%s %s",word[0],word[1]);
if (!word[0][0] || !word[1][0]) {
	write_user(user,"Uso: passwd <password antiga> <nova password>");
	return;
	}
if (strlen(word[1])>NAME_LEN-1) {
	write_user(user,"Essa password eh grande demais...");  return;
	}
if (strlen(word[1])<4) {
	write_user(user,"Essa password eh pequena demais...");  return;
	}
if (!strcmp(word[0],word[1])) {
	write_user(user,"Esta tentando mudar o que ?");  return;
	}

/* search though password file */
if (!(fpi=fopen(PASSFILE,"r"))) {
	sprintf(mess,"%s : Nao consegui abrir o arquivo de passwords :(",syserror);
	write_user(user,mess);
	write_syslog("ERROR: Couldn't open password file to read in change_pass()\n",0);
	return;
	}
if (!(fpo=fopen("tempfile","w"))) {
	sprintf(mess,"%s :  Nao consegui abrir o arquivo de passwords :(",syserror);
	write_user(user,mess);
	write_syslog("ERROR: Couldn't open tempfile to write in change_pass()\n",0);
	fclose(fpi);  return;
	}

/* go through password file */
found=0;
fgets(line,80,fpi);
while(!feof(fpi)) {
	if (found) { fputs(line,fpo);  fgets(line,80,fpi);  continue; }
	sscanf(line,"%s %s",name,passwd);
	if (!strcmp(name,ustr[user].name) && strcmp(passwd,crypt(word[0],SALT))) {
		write_user(user,"Senha incorreta!!!");
		fclose(fpi);  fclose(fpo);  unlink("tempfile");
		return;
		}
	if (!strcmp(name,ustr[user].name) && !strcmp(passwd,crypt(word[0],SALT))) {
		sprintf(mess,"%s %s\n",ustr[user].name,crypt(word[1],SALT));
		fputs(mess,fpo);  found=1;
		}
	else fputs(line,fpo);
	fgets(line,80,fpi);
	}
fclose(fpi);  fclose(fpo);

/* this shouldn't happen */
if (!found) {
	sprintf(mess,"%s : problemas na leitura do arquivo.",syserror);
	write_user(user,mess);
	write_syslog("ERROR: Bad read of password file in change_pass()\n",0);
	return;
	}

/* Make the temp file the password file. */
if (rename("tempfile",PASSFILE)==-1) {
	sprintf(mess,"%s : falha de leitura",syserror);
	write_user(user,mess);
	write_syslog("ERROR: Couldn't rename temp file to password file in change_pass()\n",0);
	return;
	}

/* Output fact of changed password. We save to syslog in case change is not done
   by accounts owner and the owner complains and so we know the time it occured
*/
write_user(user,"A password foi mudada com sucesso.");
sprintf(mess,"User %s changed their password\n",ustr[user].name);
write_syslog(mess,1);
}


/*** Do a private emote ***/
pemote(user,inpstr)
int user;
char *inpstr;
{
char other_user[ARR_SIZE];
int user2;

sscanf(inpstr,"%s ",other_user);
other_user[0]=toupper(other_user[0]);
inpstr=remove_first(inpstr);
if (!inpstr[0]) {
	write_user(user,"Uso: .pemote <user> <mensagem>");  return;
	}
if ((user2=get_user_num(other_user))==-1) {
	sprintf(mess,"%s nao esta no talker",other_user);
	write_user(user,mess);  return;
	}
if (user2==user) {
	write_user(user,"=> Nao eh aconselhavel exprimir emocoes para si proprio, isto pode carcterizar algum problema de socializacao...");
	return;
	}
if (ustr[user].vis)
	sprintf(mess,"-> [Pemote]: (%s) %s\n\r",ustr[user].name,inpstr);
else sprintf(mess,"-> Pemote de um animal %s\n\r",inpstr);
write_user(user2,mess);
if (ustr[user].vis)
	sprintf(mess,"-> [Pemote] para %s: %s %s",ustr[user2].name,ustr[user].name,inpstr);
else sprintf(mess,"-> [Pemote] para %s: Um animal %s",ustr[user2].name,inpstr);
write_user(user,mess);
}



/*** Do a shout emote ***/
semote(user,inpstr)
int user;
char *inpstr;
{
if (!inpstr[0]) {	
	write_user(user,"Uso: .semote <texto>");  return;
	}
if (!ustr[user].vis) sprintf(mess,"!! Um animal %s",inpstr);
else sprintf(mess,"!! %s %s",ustr[user].name,inpstr);
write_user(user,mess);
strcat(mess,"\n\r");
write_alluser(user,mess,1,0);
}






/***************************** EVENT FUNCTIONS *****************************/

/*** switching function ***/
void sigcall()
{
check_mess(0);
check_timeout();

/* reset alarm */
reset_alarm();
}



/*** reset alarm - first called from add_user ***/
reset_alarm()
{
signal(SIGALRM,sigcall);
alarm(ALARM_TIME);
}



/*** write to areas - if area=-1 write to all areas ***/
write_area(area,inpstr)
int area;
char *inpstr;
{
int u;
 
for (u=0;u<MAX_USERS;++u) {
	if (ustr[u].area==-1 || !ustr[u].listen) continue;
	if (ustr[u].area!=area && area!=-1) continue;
	write_user(u,inpstr);
	}
}



/*** check to see if messages are out of date ***/
check_mess(startup)
int startup;
{
int b,tm,day,day2;
char line[ARR_SIZE+1],datestr[30],timestr[7],boardfile[20],tempfile[20];
char daystr[3],daystr2[3],month[4],month2[4];
FILE *bfp,*tfp;

time((long *)&tm);
strcpy(datestr,ctime((long *)&tm));
midcpy(datestr,timestr,11,15);
midcpy(datestr,daystr,8,9);
midcpy(datestr,month,4,6);
day=atoi(daystr);

/* see if its time to check (midnight) */
if (!startup) {
	if (!strcmp(timestr,"00:01"))  {  checked=0;   return;  }
	if (strcmp(timestr,"00:00") || checked) return;
	checked=1;
	}

/* cycle through files */
sprintf(tempfile,"%s/temp",MESSDIR);
for(b=0;b<NUM_AREAS;++b) {
	sprintf(boardfile,"%s/board%d",MESSDIR,b);
	if (!(bfp=fopen(boardfile,"r"))) continue;
	if (!(tfp=fopen(tempfile,"w"))) {
		write_syslog("ERROR: Couldn't open temp file to write in check_mess()\n",0);
		fclose(bfp);
		return;
		}

	/* go through board and write valid messages to temp file */
	fgets(line,ARR_SIZE,bfp);
	while(!feof(bfp)) {
		if (line[0]!='=') {
			midcpy(line,daystr2,5,6);
			midcpy(line,month2,1,3);
			day2=atoi(daystr2);
			if (strcmp(month,month2)) day2-=30;  /* if mess from prev. month */
			}
		if (line[0]=='=' || day2>=day-MESS_LIFE) fputs(line,tfp);
		else astr[b].mess_num--;
		fgets(line,ARR_SIZE,bfp);
		}
	fclose(bfp);  fclose(tfp);
	unlink(boardfile);

	/* rename temp file to boardfile */
	if (rename(tempfile,boardfile)==-1) {
		write_syslog("ERROR: Couldn't rename temp file to board file in check_mess()\n",0);
		astr[b].mess_num=0;
		}
	}
}



/*** Boot off users who idle too long at login prompt ***/
check_timeout()
{
int secs,user,idle;

for (user=0;user<MAX_USERS;++user) {
	if (ustr[user].sock==-1) continue;
	idle=((int)time((time_t *)0)-ustr[user].last_input)/60;
	if (!ustr[user].logging_in && !ustr[user].idle_mention && idle>=IDLE_MENTION) {
		sprintf(mess2,"=> %s entra em IDLE...\n\r",ustr[user].name);
		write_alluser(user,mess2,0,0);
		write_user(user,"=> Voce acabou de entrar em estado IDLE...\n\r");
		ustr[user].idle_mention=1;
		}
	if (!ustr[user].logging_in || ustr[user].sock==-1) continue;
	secs=(int)time((time_t *)0)-ustr[user].last_input;
	if (secs>=TIME_OUT) {
		echo_on(user);
		write_user(user,"\n\n\rTime out\n\n\r");
		user_quit(user);
		}
	}
}      


/*** Uptime command ***/
uptime(user)
int user;

/* Conversion constants. */
 const long minute = 60;
 const long hour = minute * 60;
 const long day = hour * 24;
 const double megabyte = 1024 * 1024;
 /* Obtain system statistics. */
 struct sysinfo si;
 sysinfo (&si);

 sprintf ("system uptime : %ld days, %ld:%02ld:%02ld\n",  si.uptime / day, (si.uptime % day) / hour, (si.uptime % hour) / minute, si.uptime % minute);


}

