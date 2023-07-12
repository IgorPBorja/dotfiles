function git_sparse(){
	# https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository	
	remote_url = "$1" local_dir = "$2"

	mkdir -p local_dir
	cd local_dir
	git remote add -f origin remote_url

	shift 2
	for i; do
		echo "$i" >> .git/info/sparse-checkout
	done

	git pull origin main	
}
