# To add new SSH key, use:
# set --universal --append SSH_KEYS_TO_AUTOLOAD ~/.ssh/id<keyname>
# To remove a key, remove it from the list using its index:
# set --universal --erase SSH_KEYS_TO_AUTOLOAD[index_of_key]

if status is-login
    and status is-interactive
    keychain --eval $SSH_KEYS_TO_AUTOLOAD | source
end
