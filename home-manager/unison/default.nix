{ pkgs, ... }:
let
  counter_path = "/tmp/unison-sync-counter.txt";
in
{
  home.packages = with pkgs; [
    (unison.override { enableX11 = false; })
    (pkgs.writeShellApplication {
      name = "unison-sync";
      text = # bash
        ''
          run_unison() {
            unison -repeat watch+3600 -color false -auto 2>&1
          }

          counter=0
          echo $counter > ${counter_path}

          inc_counter() {
            counter=$(( "$counter" + 1 ))
            echo $counter > ${counter_path}
          }

          while true; do
            while ! ping -c 1 -W 1 8.8.8.8; do sleep 1; done

            coproc run_unison

            echo -e "\e[33mBackground Unison process started. PID: \e[1m''${COPROC_PID}\e[0m"
            echo -e "\e[33mNow outputting Unison log.\e[0m"

            while read -r line; do
              echo "$line"
              if [[ "$line" == "skipped: "* ]]; then
                inc_counter
              elif [[ "$line" == "failed: "* ]]; then
                inc_counter
              elif [[ "$line" == "Nothing to do: replicas have not changed since last sync." ]]; then
                counter=0
                echo $counter > ${counter_path}
              fi
            done <&"''${COPROC[0]}"

            sleep 20
          done
        '';
    })
    (pkgs.writeShellApplication {
      name = "unison-status";
      text = # bash
        ''
          if [[ $(pgrep -c unison) -ge 5 ]]; then
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
  home.file.".unison/dotsync.prf".source = ./dotsync.prf;
  home.file.".unison/space.prf".source = ./space.prf;
}
