if [[ ! -d '/srv/yt/downloads' ]]; then
    echo "Error: downloads/ does not exist"
    exit 1
fi

title="$(youtube-dl --get-filename -o '%(title)s' $1)"
filename="$(youtube-dl --get-filename -o '%(title)s.%(ext)s' $1)"
description="$(youtube-dl --get-description $1)"

dest_dir="/srv/yt/downloads/${title}"

if [[ ! -d "${dest_dir}" ]]; then
    mkdir "${dest_dir}"
fi

youtube-dl -o "/srv/yt/downloads/${title}/${filename}" "$1" &> /dev/null
touch "/srv/yt/downloads/${title}/description" 
youtube-dl --get-description "$1" > "/srv/yt/downloads/${title}/description"

if [[ ! -d '/var/log/yt/' ]]; then
	echo "Error : download.log does not exist"
	exit 1
fi

echo "$(sudo date +"[%y/%m/%d %H:%M:%S]")" Video $1 was downloaded. File path : /srv/yt/downloads/${title}/${filename} >> "/var/log/yt/download.log"
echo "Video $1 was downloaded."
echo "File path /srv/yt/downloads/${title}/${filename}"
