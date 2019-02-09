usage () {
  printf '\nUsage:\n./new.sh -n <username> -s\nOptions:\n[ -n ] - username of new user [required]\n[ -s ] - make new user a superuser\n'
}

while getopts "n:s" opt; do
  case ${opt} in
    n )
      name=$OPTARG
    ;;
    s )
      super=true
    ;;    
    \? )
      usage
      exit 1
    ;;
    : )
      usage
      exit 1
    ;;
  esac
done
shift $((OPTIND -1))

if [ ! $name ]; then 
  printf "${0}: name argument is required\n"
  usage
  exit 1
fi

sudo adduser $1

if [ $super ]; then
  groups=(adm cdrom sudo plugdev dip $name)
  printf "${1} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
else 
  groups=($name)
fi

for group in "${groups[@]}"; do
  sudo adduser $1 $group
done

printf '\nAll Done...\n'
