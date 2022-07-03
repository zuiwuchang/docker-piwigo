#!/usr/bin/env bash
set -e

Command="build.sh"
Version="12.2.0-w"
Tag="king011/piwigo:$Version"
RunName="dev-piwigo"

function display_help
{
    echo "build $Tag"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo
    echo "Flags:"
    echo '  -e,--exec         exec container'
    echo '  -b,--build          build docker image'
    echo '  -d,--delete         delete container'
    echo '  -r,--run            run docker container'
    echo "  -h, --help          help for $Command"
}
function build_image
{
    cd $(dirname $BASH_SOURCE)
    if [ -d cnf.tmp ];then
        rm cnf.tmp -rf
    fi
    cp ../cnf ./cnf.tmp -r
    set -x
    sudo docker build \
        --network host \
        -t "$Tag" .
}
function exec_container
{
    set -x
    sudo docker exec -it "$RunName" bash
}
function delete_container
{
    set -x
    sudo docker rm -f "$RunName"
}
function run_container
{
    cd $(dirname $BASH_SOURCE)
    local dir=`pwd`

    set -x
    sudo docker run \
        --name "$RunName"   \
        -e TZ="Asia/Shanghai" \
        -p 8800:80/tcp \
        -p 9000:81/tcp \
        -v "$dir/data.tmp":/data \
        -d "$Tag"
}

ARGS=`getopt -o hebdr --long help,exec,build,delete,run -n "$Command" -- "$@"`
eval set -- "${ARGS}"
_Exec=0
_Build=0
_Delete=0
_Run=0

while true
do
    case "$1" in
        -h|--help)
            display_help
            exit 0
        ;;
        -e|--exec)
            _Exec=1
            shift
        ;;
        -b|--build)
            _Build=1
            shift
        ;;
        -d|--delete)
            _Delete=1
            shift
        ;;
        -r|--run)
            _Run=1
            shift
        ;;
        --)
            shift
            break
        ;;
        *)
            echo Error: unknown flag "$1" for "$Command"
            echo "Run '$Command --help' for usage."
            exit 1
        ;;
    esac
done


if [[ $_Exec == 1 ]];then
    exec_container
    exit $?
fi

if [[ $_Build == 1 ]];then
    build_image
    exit $?
fi

if [[ $_Delete == 1 ]];then
    delete_container
    exit $?
fi

if [[ $_Run == 1 ]];then
    run_container
    exit $?
fi
display_help
exit 1
