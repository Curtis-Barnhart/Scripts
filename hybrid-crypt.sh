hybrid-crypt-send() {
    # make a symmetric encryption password of 256 random bytes
    gpg --gen-random 1 256 > symmetric_password

    # encrypt that password asymmetrically
    gpg --encrypt symmetric_password

    # use the original symmetric encryption password to encrypt original target file
    gpg --symmetric --batch --passphrase-file symmetric_password $1

    # wrap up the encrypted symmetric password and file to encrypt in an archive
    tar -cf ${1}_encrypted.tar ${1}.gpg symmetric_password.gpg

    # remove the temporarily created symmetric password and the encrypted file
    rm symmetric_password symmetric_password.gpg ${1}.gpg
}

hybrid-crypt-read() {
    local name_length

    # get the name of the original file that was encrypted (it's whatever file isn't the symmetric password)
    # (this assumes that only one file was encrypted)
    local encrypted_file=$(tar --list -f $1 | grep --invert-match symmetric_password.gpg)

    # unarchive the archive, giving us encrypted file and encrypted symmetric password
    tar -xf $1

    # decrypt the symmetric password...
    gpg --decrypt symmetric_password.gpg > symmetric_password

    # ...and use it to decrypt the encrypted file
    # getting rid of ".gpg"
    declare -i name_length=$((${#encrypted_file} - 4))
    gpg --decrypt --batch --passphrase-file symmetric_password $encrypted_file > ${encrypted_file:0:name_length}

    # then remove the temporarily created symmetric password and the encrypted file
    rm symmetric_password symmetric_password.gpg $encrypted_file
}

