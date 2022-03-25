#!/usr/bin/env bash
set -e

cd $(dirname $BASH_SOURCE)

Command="db.sh"
Container="dev-piwigo-db"
function display_help
{
    echo "db help"
    echo
    echo "Usage:"
    echo "  $Command [flags]"
    echo
    echo "Flags:"
    echo '  -r,--run         run db container'
    echo '  -e,--exec          exec db container'
    echo '  -d,--delete         delete db container'
    echo "  -h, --help          help for $Command"
}

ARGS=`getopt -o hred --long help,run,exec,delete -n "$Command" -- "$@"`
eval set -- "${ARGS}"
_Run=0
_Exec=0
_Delete=0

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
    set -x
    sudo docker exec -it "$Container" bash
    exit $?
fi

if [[ $_Delete == 1 ]];then
    set -x
    sudo docker exec rm -f "$Container"
    exit $?
fi

if [[ $_Run == 1 ]];then
    set -x
    sudo docker run \
                --name "$Container" \
                --restart always \
                -p 3306:3306 \
                -v $(pwd)/mysql:/var/lib/mysql \
                -e MYSQL_ROOT_PASSWORD=123 \
                -d mariadb:10.5.9
    exit $?
fi
display_help
exit 1
