function firedep --description 'Deploy a Firebase hosting preview channel'
    npx --yes firebase-tools hosting:channel:deploy $argv[1]
end
