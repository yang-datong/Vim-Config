#!/bin/bash
set -e

#-------------------- Generate Content --------------------
ARCHIVE_START_LINE=$(awk '/^__ARCHIVE_BELOW__/ {print NR + 1; exit 0; }' $0)
date=$(date +"%Y%m%d%H%M%S")
tail -n+${ARCHIVE_START_LINE} $0 > ./temp_$date.zip
unzip temp_$date.zip > /dev/null && rm temp_$date.zip
#-------------------- dd.sh --------------------
#!/bin/bash

unset file

macos(){
	file="$HOME/Library/Application Support/abnerworks.Typora/themes/base.user.css"
}

ubuntu(){
	file="$HOME/.config/Typora/themes/base.user.css"
}


check_os(){
	case "$(uname)" in
	"Darwin") macos;;
	"Linux") ubuntu;;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os

mv base.user.css "$file"
#------------------------------------------
exit 0 
__ARCHIVE_BELOW__
PK    ]�|XԖꈧ  �    base.user.cssUT	 Q^fR^fux �     �W˒�0��S�K�
vIpU.��\�d�Z,���ͣ��3�_Җaw+��i��[3�Y�t9���,J����
�T\���{Dn�68�|��qqW�\x���s�j�\L���4��݄�RE�K����G�k��	]o�+}�b9�!�[\2X�n��H��p3v�uve�\n����k��yg$�&�^M: ض�\��ן��&�~K�K��l�%Zb�%F�O�c�^j�f^+m0�L����c�m���;J��ɤ
�E��P1��b��A��eoK�ܭ�n\Z�ڰp�h�n���<�^o�^�^��.�[<��=�%ȋz�b����E����Q�W:�k��k�_�v���?����Y{_��7�W��ke�`!���N1��<(��m����y;��Y`��}L*�X`Z���a��[C�^3�v��O��S�s9�#��a-��so�&�����뗪������(����yqS�k��f%2�x�@�v�������xUPne��X��~����e�@:�I���,9��� �v��2y�E���An����^Un�W��/��\�k����v(�B�$&v�o8ոH&�N� �uc�U�9��E��w���R���;:��n~�������S{�$J�cwV��)c�L5�����r+,s=0ö��Kv�<:� PK    ]�|XԖꈧ  �           ��    base.user.cssUT Q^fux �     PK      S   �    
