emacs_config="$HOME/.config/doom"
bash_scripts="$HOME/scripts"
texmf="$HOME/texmf"
repo="$HOME/config-repo"

message=""

while getopts 'm:' flag; do
	case "${flag}" in
		m) message=${OPTARG} ;;
		*) echo "Unexpected arguments" 
		exit 1 ;;
	esac
done

if [ "$message" = "" ] 
then
	echo "Empty commit message: aborting"
	exit 1
fi

cp -r "$emacs_config" "$repo"
cp -r "$bash_scripts" "$repo"
cp -r "$texmf" "$repo"

dir=$(pwd)
cd $repo
git add .
git commit -m "$message"
git push 

cd $dir

