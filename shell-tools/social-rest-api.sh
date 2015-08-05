#!/bin/bash
USER_ME=$(whoami);
CL_NC='\e[0m' # No CL
CL_WHITE='\e[1;37m'
CL_BLACK='\e[0;30m'
CL_BLUE='\e[0;34m'
CL_LIGHT_BLUE='\e[1;34m'
CL_GREEN='\e[0;32m'
CL_LIGHT_GREEN='\e[1;32m'
CL_CYAN='\e[0;36m'
CL_LIGHT_CYAN='\e[1;36m'
CL_RED='\e[0;31m'
CL_LIGHT_RED='\e[1;31m'
CL_PURPLE='\e[0;35m'
CL_LIGHT_PURPLE='\e[1;35m'
CL_BROWN='\e[0;33m'
CL_YELLOW='\e[1;33m'
CL_GRAY='\e[0;30m'
CL_LIGHT_GRAY='\e[0;37m'


function INFO() {
  if [ -n "$1" ]; then
     echo -e "[INFO] [$1]";
  fi 
}
function hasfc() {
  command -v $1 >/dev/null && echo "Found" || echo "NotFound"
}
function containText() {
	int1="$1";# B
	int2="$2";# A
	X=${int2/$int1/};
	if [ "$X" == "$int2" ]; then
		echo "NOK";
	else
		echo "OK";
	fi
}
if [ $(hasfc python) == "NotFound" ] && [ $(hasfc apt-get) == "Found" ]; then
  eval "sudo apt-get install python";
fi
#GET /rest/v1/social/relationships #Gets all the relationships 
#POST /rest/v1/social/relationships -d {data} #Add a relationship 

#GET /rest/v1/social/relationships/{id} #Gets a relationship with the given id
#PUT /rest/v1/social/relationships/{id} #Updates a relationship with the given id 
#DELETE /rest/v1/social/relationships/{id} #Deletes a relationship with the given id


#GET /rest/v1/social/users?q=xx* #find  all users by q
#POST /rest/v1/social/users -d '{json of user}' #create user

#GET /rest/v1/social/users/{userId} #get user by id
#PUT /rest/v1/social/users/{userId} #update users
#DELETE /rest/v1/social/users/{userId} #remove users

#GET /rest/v1/social/users/{userId}/connections #Gets all the users connected with the user with the given id 
#GET /rest/v1/social/users/{userId}/spaces  #Gets all the spaces of the user with the given id 

#GET /rest/v1/social/users/{userId}/activities?type=connections|owner&after=xxx&before=yyy #Gets all the activities of the user with the given id 

#POST /rest/v1/social/users/{userId}/activities -d '{data}' #Post an activity in the activity stream of the user with the given id 

#GET /rest/v1/social/usersRelationships?user={userId}&status=all|pending|confirmed #Gets all the users relationships 

#POST /rest/v1/social/usersRelationships -d {data} #Add an users relationship 

#GET /rest/v1/social/usersRelationships/{id} #Gets an users relationship with the given id 
#PUT /rest/v1/social/usersRelationships/{id} -d {data} #Updates an users relationship with the given id 
#DELETE /rest/v1/social/usersRelationships/{id} #Deletes an users relationship with the given id

#GET /rest/v1/social/spaces?q=xx* #Gets all the spaces 
#POST /rest/v1/social/spaces -d {data} #Creates a space 

#GET /rest/v1/social/spaces/{spaceId} #Gets a space with the given id 
#PUT /rest/v1/social/spaces/{spaceId} #Updates a space with the given id 
#DELETE /rest/v1/social/spaces/{spaceId} #Deletes a space with the given id

#GET /rest/v1/social/spaces/{spaceId}/users?role=manager|member #Gets all the users of the space with the given id 

#GET /rest/v1/social/spaces/{spaceId}/activities?after=xxx&before=yyy #Gets all the activities of the space with the given id 
#POST /rest/v1/social/spaces/{spaceId}/activities -d {data} #Post an activity in the activity stream of the space with the given id

#GET /rest/v1/social/spacesMemberships?status=all|pending|approved&user={userId}&space={spaceId} #Gets all the spaces memberships 
#POST /rest/v1/social/spacesMemberships -d { "userId"={userId}, "spaceId"={spaceId} } # Add an user in a space 

#GET /rest/v1/social/spacesMemberships/{spaceId} #Gets a space membership with the given id
#PUT /rest/v1/social/spacesMemberships/{spaceId} #Updates a space membership with the given id 
#DELETE /rest/v1/social/spacesMemberships/{spaceId} #Deletes a space membership with the given id (withdraw an user from a space) 

#GET /rest/v1/social/identities #Gets all the identities 
#POST /rest/v1/social/identities -d {data} #Creates an identity 

#GET /rest/v1/social/identities/{id} #Gets an identity with the given id 
#PUT /rest/v1/social/identities/{id} #Updates an identity with the given id
#DELETE /rest/v1/social/identities/{id} #Deletes an identity with the given id   

#GET /rest/v1/social/identities/{id}/relationships #Gets all the relationships of the identity with the given id 

#GET /rest/v1/social/activities #Gets all the activities

#GET /rest/v1/social/activities/{activityId} #Gets an activity with the given id 
#PUT /rest/v1/social/activities/{activityId} #Updates an activity with the given id 
#DELETE /rest/v1/social/activities/{activityId} #Deletes an activity with the given id 


#GET /rest/v1/social/activities/{activityId}/comments?offset=0&limit=5 #Gets all the comments of the activity with the given id 
#POST /rest/v1/social/activities/{activityId}/comments #Post a comment for the activity with the given id 

#GET /rest/v1/social/activities/{activityId}/likes?offset=0&limit=5 #Gets all the likes of the activity with the given id 
#POST /rest/v1/social/activities/{activityId}/likes #Add a like for the activity with the given id 

#GET /rest/v1/social/activities/{activityId}/likes/{username} #Gets the like of the user with the given username for the activity with the given activity id 
#DELETE /rest/v1/social/activities/{activityId}/likes/{username} #Delete a like from the user with the given username on the activity with the given activity id

#GET /rest/v1/social/comments #Gets all the comments 

#GET /rest/v1/social/comments/{commentId} #Gets a comment with the given id 
#PUT /rest/v1/social/comments/{commentId} #Updates a comment with the given id 
#DELETE /rest/v1/social/comments/{commentId} #Delete a comment with the given id 
#

#curl -X METHOD URL -d '{jsonData}'

usage_rest()
{
cat << EOF

  Welcome $USER_ME!
  
  This script run to GET|POST|PUT|DELETE the rest url of Social Rest APIs

  FUNCTION:
      restconfig          - Use for configuration rest: user login, localhost
      loginrest           - Support to login user
      users               - Support all method for url:/rest/v1/social/users
      usersRelationships  - Support all method for url:/rest/v1/social/usersRelationships
      spaces              - Support all method for url:/rest/v1/social/spaces
      spacesMemberships   - Support all method for url:/rest/v1/social/spacesMemberships
      identities          - Support all method for url:/rest/v1/social/identities
      activities          - Support all method for url:/rest/v1/social/activities
      comments            - Support all method for url:/rest/v1/social/comments


  Example:
    - Configuration rest: restconfig server=http://localhost:8080 login=root:gtn rest=rest
    - Create new user: users method=POST data="\\{'username':'user_test','password':'gtngtn','firstname':'Firstname','lastname':'Lastname','gender':'Gender'\\}"
  Default value:
    - Rest: rest
    - User login: root:gtn
    - Server URL: http://localhost:8080
    - Version: v1/social
    - Method: GET
  Note:
    - This script support auto-suggestion, so we can easy use press Tab keyword to show all params of function.
    - More detail of each REST APIs, you can use help param, example: users help

EOF

}
usage_rest;

function restapi() {
  usage_rest;
}

SERVER_INJECT="http://localhost:8080"
REST_INJECT="rest"
USER="root:gtn";
METHOD="GET"
DATA="";
VERSION="v1/social";
function callRestAPI() {
  FUNSTION="";
  GETPARAM="";
  METHOD="GET"
  OPTSTRING="h:f:m:a:b:c:d:p:r:u:";
  while getopts ${OPTSTRING} OPTION
  do
       case $OPTION in
           h)# server
               SERVER_INJECT=$OPTARG
               ;;
           f)# function name
               FUNSTION=$OPTARG
               ;;
           m)# method
               METHOD=$OPTARG
               ;;
           a)# path params 1
               P1=$OPTARG
               ;;
           b)# path params 2
               P2=$OPTARG
               ;;
           c)# path params 3
               P3=$OPTARG
               ;;
           d)# put/post data
               DATA=$OPTARG
               ;;
           p)# query params
               GETPARAM=$OPTARG
               ;;
           r)# rest name
               REST_INJECT=$OPTARG
               ;;
           u)# user info
               USER=$OPTARG
               ;;
           ?)
               usage_rest
               ;; 
       esac
  done
  # unset getopts variables
  shift $(( OPTIND - 1 ));
  unset OPTSTRING;
  unset OPTIND;
  unset OPTARG;
  unset DATA;
  
  # Run
  if [ -n "$FUNSTION" ];  then
    echo "process $FUNSTION";
    URL="$SERVER_INJECT/$REST_INJECT/private/$VERSION/$FUNSTION";
    if [ -n "$P1" ];then
      URL="$URL/$P1";
    fi
    if [ -n "$P2" ];then
      URL="$URL/$P2";
    fi
    if [ -n "$P3" ];then
      URL="$URL/$P3";
    fi
    if [ -n "$GETPARAM" ];then
      URL="$URL?$GETPARAM";
    fi
    DATA="${data//\'/\"}";
    URLDATA="";
    if [ "$METHOD" == "POST" ] || [ "$METHOD" == "PUT" ]; then
      if [ -n "$DATA" ];then
        URLDATA="-d '$DATA' -H 'Content-Type: application/json'";
      else 
        echo "Missing json data.";
      fi
    fi
    
    local py="";
    if [ $(containText "jsonp" "$GETPARAM") == "NOK" ] && [ $(hasfc python) == "Found" ]; then
      py="python -m json.tool";
    fi
    
    INFO "curl -X $METHOD -u $USER -s -w -v '$URL' $URLDATA";
    if [ -n "$py" ]; then
      eval "curl -X $METHOD -u $USER -s -w -v '$URL' $URLDATA | sed -e 's/-v//g' | $py";
    else
      eval "time curl -X $METHOD -u $USER -s -w -v '$URL' $URLDATA | sed -e 's/{/\n\{/g'";
    fi
  else 
    usage_rest;
  fi
}
##======================================================================
function restconfig() {
  login="";
	server=""

	for arg  in "$@" 
  do
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      eval "$arg";
    fi
  done
  
 	if [ -n "$login" ]; then 
		login="${login/login=/}";
		USER="$login";
	fi

 	if [ -n "$server" ]; then 
		server="${server/server=/}";
		SERVER_INJECT="$server";
	fi
  if [ -n "$rest" ]; then 
		rest="${rest/rest=/}";
		REST_INJECT="$rest";
	fi
  if [ -n "$version" ]; then 
		version="${version/version=/}";
		VERSION="$version";
	fi
	INFO "login=$USER server=$SERVER_INJECT rest=$REST_INJECT version=$VERSION"
}
_restconfig()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="server=http://localhost:8080 login=root:gtn rest=rest version=v1/social"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_restconfig" -o "default" "restconfig"
##======================================================================

function users() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of users";
      echo "      GET /rest/v1/social/users?q={q}"
      echo "      POST /rest/v1/social/users -d '{data}'"
      echo "      GET /rest/v1/social/users/{userId}"
      echo "      PUT /rest/v1/social/users/{userId} -d {data}"
      echo "      DELETE /rest/v1/social/users/{userId}"
      echo "      GET /rest/v1/social/users/{userId}/connections"
      echo "      GET /rest/v1/social/users/{userId}/spaces"
      echo "      GET /rest/v1/social/users/{userId}/activities?type=connections|owner&after={after}&before={before}"
      echo "      POST /rest/v1/social/users/{userId}/activities -d '{data}'"
      echo "         Main params:"
      echo "      method: it is Verb (GET|POST|PUT|DELETE)";
      echo "      q: it is value of query params 'q'. Only use for case: ../users?q={q}";
      echo "      data: it is data json input";
      echo "      Example: users method=GET userId=demo connections";
      echo "      users method=POST data=\"\\{'username':'user_test','password':'gtngtn','firstname':'Firstname','lastname':'Lastname','gender':'Gender'\\}\"";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      echo $arg;
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      echo "Need add data for method POST or PUT";
      echo "Example: data=\"{'username':'Username','firstname':'Firstname','lastname':'Lastname','gender':'Gender'}\"";
      DO="";
    fi
  fi
  #
  local AND="";
  local query="";
  if [ -n "$q" ]; then
    query="q=$q";
    AND="&"
  else
    if [ -n "$type" ]; then
      query="type=$type";
      AND="&"
    fi
    if [ -n "$before" ]; then
      query="$query${AND}before=$before"
      AND="&"
    fi
    if [ -n "$after" ]; then
      query="$query${AND}after=$after"
      AND="&"
    fi
  fi
  
  if [ -n "$offset" ]; then
    query="$query${AND}offset=$offset";
    AND="&"
  fi
  if [ -n "$limit" ]; then
    query="$query${AND}limit=$limit";
    AND="&"
  fi
  if [ -n "$jsonp" ]; then
    query="$query${AND}jsonp=$jsonp";
    AND="&"
  fi
  if [ -n "$returnSize" ]; then
    query="$query${AND}returnSize=$returnSize";
    AND="&"
  fi
  if [ -n "$fields" ]; then
    query="$query${AND}fields=$fields";
    AND="&"
  fi
  if [ -n "$expand" ]; then
    query="$query${AND}expand=$expand";
  fi
  if [ -n "$DO" ]; then
    eval "callRestAPI -f users -m $method -p '$query' -a '$userId' -b '$P2' -d \"$data\"";
  fi
}
_users()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET jsonp=jsonp expand=identity fields=username,email q=user* data={json} userId=demo connections spaces activities type=connections offset=0 limit=20 returnSize=true before=datetime after=datetime"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_users" -o "default" "users"
##======================================================================
function usersRelationships() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of usersRelationships";
      echo "      GET /rest/v1/social/usersRelationships?user={userId}&status={status}"
      echo "      POST /rest/v1/social/usersRelationships -d {data}"
      echo "      GET /rest/v1/social/usersRelationships/{id}"
      echo "      PUT /rest/v1/social/usersRelationships/{id} -d {data}"
      echo "      DELETE /rest/v1/social/usersRelationships/{id}"
      echo "         Main params:"
      echo "      method: it is Verb (GET|POST|PUT|DELETE)";
      echo "      data: it is data json input data=\"\\{'receiver':'{userId}','status':'pending or confirm'\\}\"";
      echo "      status: value in (all, pending, confirmed)";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      INFO "Need add data for method POST or PUT";
      INFO "Example: data=\"{}\"";
      DO="";
    fi
  fi
  #
  local AND="";
  local query="";
  if [ -n "$user" ]; then
    query="user=$user";
    AND="&"
  fi
  if [ -n "$status" ]; then
    query="$query${AND}status=$status";
    AND="&"
  fi
  if [ -n "$offset" ]; then
    query="$query${AND}offset=$offset";
    AND="&"
  fi
  if [ -n "$limit" ]; then
    query="$query${AND}limit=$limit";
    AND="&"
  fi
  if [ -n "$jsonp" ]; then
    query="$query${AND}jsonp=$jsonp";
    AND="&"
  fi
  if [ -n "$returnSize" ]; then
    query="$query${AND}returnSize=$returnSize";
    AND="&"
  fi
  if [ -n "$DO" ]; then
    eval "callRestAPI -f usersRelationships -m $method -p '$query' -a '$id' -d \"$data\"";
  fi
}
_usersRelationships()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET data={json} user=demo status=all id=relationshipsId offset=0 limit=20 returnSize=true"
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_usersRelationships" -o "default" "usersRelationships"
##======================================================================
function spaces() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of spaces";
      echo "      GET /rest/v1/social/spaces?q={q}"
      echo "      POST /rest/v1/social/spaces -d {data}"
      echo "      GET /rest/v1/social/spaces/{spaceId}"
      echo "      PUT /rest/v1/social/spaces/{spaceId} -d {data}"
      echo "      DELETE /rest/v1/social/spaces/{spaceId}"
      echo "      GET /rest/v1/social/spaces/{spaceId}/users?role={role}"
      echo "      GET /rest/v1/social/spaces/{spaceId}/activities?after={after}&before={before}"
      echo "      POST /rest/v1/social/spaces/{spaceId}/activities -d {data}"
      echo "         Main params:"
      echo "      method: it is Verb (GET|POST|PUT|DELETE)";
      echo "      data: it is data json input";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      INFO "Need add data for method POST or PUT";
      INFO "Example: data=\"{}\"";
      DO="";
    fi
  fi
  #
  local query="";
  local AND="";
  if [ -n "$q" ]; then
    query="q=$q";
    AND="&";
  else
    if [ -n "$role" ]; then
      query="role=$role";
      AND="&";
    fi
    if [ -n "$after" ]; then
      query="$query${AND}after=$after";
      AND="&";
    fi
    if [ -n "$before" ]; then
      query="$query${AND}before=$before";
      AND="&";
    fi
    if [ -n "$spaceId" ]; then
      query="$query${AND}spaceId=$spaceId";
      AND="&";
    fi
  fi

  if [ -n "$offset" ]; then
    query="$query${AND}offset=$offset";
    AND="&"
  fi
  if [ -n "$limit" ]; then
    query="$query${AND}limit=$limit";
    AND="&"
  fi
  if [ -n "$jsonp" ]; then
    query="$query${AND}jsonp=$jsonp";
    AND="&"
  fi
  if [ -n "$fields" ]; then
    query="$query${AND}fields=$fields";
    AND="&"
  fi
  if [ -n "$returnSize" ]; then
    query="$query${AND}returnSize=$returnSize";
    AND="&"
  fi
  if [ -n "$expand" ]; then
    query="$query${AND}expand=$expand";
  fi
  
  if [ -n "$DO" ]; then
    eval "callRestAPI -f spaces -m $method -p '$query' -a '$spaceId' -b '$P2' -d \"$data\"";
  fi
}
_spaces()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET jsonp=jsonp expand=identity,members spaceId=spaceId fields=id,displayName data={json} q=space* users activities role=member spaceId=spaceID offset=0 limit=20 returnSize=true after=dd/mm/yyyy before=dd/mm/yyyy" 
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_spaces" -o "default" "spaces"
##======================================================================
function spacesMemberships() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of spacesMemberships";
      echo "      GET /rest/v1/social/spacesMemberships"
      echo "      GET /rest/v1/social/spacesMemberships?status={status}&user={userId}&space={spaceId}"
      echo "      POST /rest/v1/social/spacesMemberships -d {data }"
      echo "      GET /rest/v1/social/spacesMemberships/{spaceId}"
      echo "      PUT /rest/v1/social/spacesMemberships/{spaceId} -d {data}"
      echo "      DELETE /rest/v1/social/spacesMemberships/{spaceId}"
      echo "         Main params:"
      echo "      method: it is Verb (GET|POST|PUT|DELETE)";
      echo "      data: it is data json input";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      INFO "Need add data for method POST or PUT";
      INFO "Example: data=\"{}\"";
      DO="";
    fi
  fi
  #
  local query="";
  local AND="";
  if [ -n "$user" ]; then
    query="user=$user";
    AND="&";
  fi
  if [ -n "$status" ]; then
    query="$query${AND}status=$status";
    AND="&";
  fi
  if [ -n "$space" ]; then
    query="$query${AND}space=$space";
  fi

  if [ -n "$DO" ]; then
    eval "callRestAPI -f spacesMemberships -m $method -p '$query' -a '$spaceId' -d \"$data\"";
  fi
}
_spacesMemberships()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET data={json} spaceId=spaceID status=status user=userId space=spaceId" 
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_spacesMemberships" -o "default" "spacesMemberships"
##======================================================================
function identities() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of identities";
      echo "      GET /rest/v1/social/identities"
      echo "      GET /rest/v1/social/identities/{id}"
      echo "      DELETE /rest/v1/social/identities/{id}"
      echo "      GET /rest/v1/social/identities/{id}/relationships"
      echo "         Main params:"
      echo "      method: it is Verb (GET|DELETE)";
      echo "      data: it is data json input";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      INFO "Need add data for method POST or PUT";
      INFO "Example: data=\"{}\"";
      DO="";
    fi
  fi

  local query="";
  local AND="";
  if [ -n "$offset" ]; then
    query="offset=$offset";
    AND="&"
  fi
  if [ -n "$limit" ]; then
    query="$query${AND}limit=$limit";
    AND="&"
  fi
  if [ -n "$jsonp" ]; then
    query="$query${AND}jsonp=$jsonp";
    AND="&"
  fi
  if [ -n "$returnSize" ]; then
    query="$query${AND}returnSize=$returnSize";
    AND="&"
  fi
  if [ -n "$fields" ]; then
    query="$query${AND}fields=$fields";
  fi
  
  #
  if [ -n "$DO" ]; then
    eval "callRestAPI -f identities -m $method -p '$query' -a '$id' -b '$P2' -d \"$data\"";
  fi
}
_identities()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET jsonp=jsonp fields=remoteId,providerId data={json} id=identityId relationships offset=0 limit=20 returnSize=true" 
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_identities" -o "default" "identities"
##======================================================================
function activities() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of activities";
      echo "      GET /rest/v1/social/activities?offset={offset}&limit={limit}"
      echo "      GET /rest/v1/social/activities/{activityId}"
      echo "      PUT /rest/v1/social/activities/{activityId} -d {data}"
      echo "      DELETE /rest/v1/social/activities/{activityId}"
      echo "      GET /rest/v1/social/activities/{activityId}/comments?offset={offset}&limit={limit}"
      echo "      POST /rest/v1/social/activities/{activityId}/comments -d {data}"
      echo "      GET /rest/v1/social/activities/{activityId}/likes?offset={offset}&limit={limit}"
      echo "      POST /rest/v1/social/activities/{activityId}/likes"
      echo "      GET /rest/v1/social/activities/{activityId}/likes/{username}"
      echo "      DELETE /rest/v1/social/activities/{activityId}/likes/{username}"
      echo "         Main params:"
      echo "      method: it is Verb (GET|POST|PUT|DELETE)";
      echo "      data: it is data json input";
      echo "      expand: it is expand href link to json example: expand='identity\(offset:0,limit:2\)'";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      INFO "Need add data for method POST or PUT";
      INFO "Example: data=\"{}\"";
      DO="";
    fi
  fi
  #
  local query="";
  local AND="";
  if [ -n "$offset" ]; then
    query="offset=$offset";
    AND="&"
  fi
  if [ -n "$limit" ]; then
    query="$query${AND}limit=$limit";
    AND="&"
  fi
  if [ -n "$jsonp" ]; then
    query="$query${AND}jsonp=$jsonp";
    AND="&"
  fi
  if [ -n "$fields" ]; then
    query="$query${AND}fields=$fields";
    AND="&"
  fi
  if [ -n "$returnSize" ]; then
    query="$query${AND}returnSize=$returnSize";
    AND="&"
  fi
  if [ -n "$expand" ]; then
    query="$query${AND}expand=$expand";
  fi

  if [ -n "$DO" ]; then
    eval "callRestAPI -f activities -m $method -p '$query' -a '$activityId' -b '$P2' -c '$username' -d \"$data\"";
  fi
}
_activities()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET data={json} jsonp=jsonp expand=identity fields=title,body activityId=activityID comments likes username=demo offset=0 limit=20 returnSize=true" 
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_activities" -o "default" "activities"
##======================================================================
function comments() {
  
  DO="DO";
  data="";
  method="";
  query="";
  local P2="";
  for arg  in "$@" 
  do
    if [ "$arg" == "help" ]; then
      echo "         Rest URL of comments";
      echo "      GET /rest/v1/social/comments?offset={offset}&limit={limit}"
      echo "      GET /rest/v1/social/comments/{commentId}"
      echo "      GET /rest/v1/social/comments/{commentId} -d {data}"
      echo "      GET /rest/v1/social/comments/{commentId}"
      echo "         Main params:"
      echo "      method: it is Verb (GET|POST|PUT|DELETE)";
      echo "      data: it is data json input";
      DO="";
    fi
    x=`expr index "$arg" "="`;
    if [ $x -gt 0 ]; then
      arg="${arg//\'/\\\'}";
      eval "local $arg";
    else
      P2="$arg";
    fi
  done
  if [ ! -n "$method" ]; then
     method="GET";
  fi
  if [ "$method" == "POST" ] || [ "$method" == "PUT" ]; then
    if [ ! -n "$data" ]; then
      echo "Need add data for method POST or PUT";
      echo "Example: data=\"{}\"";
      DO="";
    fi
  fi
  #
  local query="";
  local AND="";
  if [ -n "$offset" ]; then
    query="offset=$offset";
    AND="&"
  fi
  if [ -n "$limit" ]; then
    query="$query${AND}limit=$limit";
    AND="&"
  fi
  if [ -n "$jsonp" ]; then
    query="$query${AND}jsonp=$jsonp";
    AND="&"
  fi
  if [ -n "$returnSize" ]; then
    query="$query${AND}returnSize=$returnSize";
    AND="&"
  fi
  if [ -n "$fields" ]; then
    query="$query${AND}fields=$fields";
  fi
  #
  if [ -n "$DO" ]; then
    eval "callRestAPI -f comments -m $method -a '$commentId' -p '$query' -d \"$data\"";
  fi
}
_comments()  
{
  local cur="${COMP_WORDS[COMP_CWORD]}"
  # The params
  local opts="help method=GET data={json} commentId=commentID jsonp=jsonp expand=identity fields=id,body offset=0 limit=20 returnSize=true" 
  # Array variable storing the possible completions.
  COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F "_comments" -o "default" "comments"



function loginrest() {
   if [ -n "$1" ]; then
      USER="$1";
      INFO "user login=$USER";
   else 
      INFO "Input the user infomation to login, example: loginrest mary:gtn";
   fi 
}















