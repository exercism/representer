#!/usr/bin/env bash

# LAMF documentado en español

# #!/usr/bin/env bash Shebang que localiza e invoca el intérprete de Bash en el entorno del sistema.

set -euo pipefail
set -f

# set -f Desactiva la expansión de comodines (globbing) para evitar que los corchetes '[', ']' desencadenen búsquedas de archivos.
# -e Finaliza inmediatamente la ejecución si algún comando devuelve un código de salida diferente de cero.
# -u Trata las variables no definidas como un error al intentar expandirlas.
# -o pipefail Provoca que una tubería (pipe) retorne el código de error del último comando que falló dentro de ella.

main() {
    local input="${1:-}"
    local len="${#input}"

    local i char
    local stack=()
    local top=0

    # -----------------------------------------------------------------------------
    # Recorrido in-process carácter por carácter en O(N)
    # -----------------------------------------------------------------------------
    for (( i=0; i<len; i++ )); do
        char="${input:i:1}"

        case "$char" in
            '(')
                stack[top++]=")"
                ;;
            '[')
                stack[top++]="]"
                ;;
            '{')
                stack[top++]="}"
                ;;
            ')'|']'|'}')
                # Si encontramos un cierre pero la pila está vacía, no hay apertura previa
                if (( top == 0 )); then
                    echo "false"
                    return 0
                fi

                # Extraer el elemento esperado de la cima de la pila (Pop)
                (( top-- ))
                if [[ "${stack[top]}" != "$char" ]]; then
                    echo "false"
                    return 0
                fi
                ;;
            *)
                # Ignorar cualquier otro carácter no delimitador
                ;;
        esac
    done

    # stack[top++]="..." Implementación de Pila LIFO en memoria C de Bash con índice 'top' O(1).

    # -----------------------------------------------------------------------------
    # Evaluación final del estado de la Pila
    # -----------------------------------------------------------------------------
    if (( top == 0 )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"

# main "$@" Pasa la cadena de expresión manteniendo caracteres especiales y LaTeX intactos.