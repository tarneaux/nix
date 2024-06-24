{ pkgs, ... }:
let
  counter_path = "/tmp/unison-sync-counter.txt";
in
{
  home.packages = with pkgs; [
    (unison.override { enableX11 = false; })
    (pkgs.writeShellApplication {
      name = "unison-sync";
      text = /* bash */ ''
        run_unison() {
          unison -repeat watch+3600 -color false -auto 2>&1
        }

        counter=0
        echo $counter > ${counter_path}

        inc_counter() {
          counter=$(( "$counter" + 1 ))
          echo $counter > ${counter_path}
        }

        coproc run_unison

        echo -e "\e[33mBackground Unison process started. PID: \e[1m''${COPROC_PID}\e[0m"
        echo -e "\e[33mNow outputting Unison log.\e[0m"

        while read -r line; do
          echo "$line"
          if [[ "$line" == "skipped: "* ]]; then
            inc_counter
          elif [[ "$line" == "failed: "* ]]; then
            inc_counter
          fi
        done <&"''${COPROC[0]}"

        rm ${counter_path}
      '';
    })
    (pkgs.writeShellApplication {
      name = "unison-status";
      text = /* bash */ ''
        if [[ $(pgrep -c unison) -ge 4 ]]; then
          errs=$(cat ${counter_path})
          if [[ "$errs" == 0 ]]; then
            echo "OK"
          else
            echo "($errs)"
          fi
        else
          echo "DOWN"
        fi
      '';
    })
  ];
  home.file.".unison/default.prf".source = ./config/unison-default.prf;
}
