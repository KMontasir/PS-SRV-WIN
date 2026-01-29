### FONCTION #############################################################################

function f_choix_dhcp {

    Write-Host "`n*** MENU GESTION DHCP :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Autoriser ce serveur DHCP dans un Active Directory
    `n2 - Ajouter les options clients (DNS, routeur, ...)
    `n3 - Creer une etendue
    `n4 - Reserver une adresse IP pour une machine
    `n5 - Quitter `n"

    $choix = Read-Host "`n*** Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            $dc = Read-Host "Entrer le nom du controleur de domaine (ex: dc.domaine.local)"
            Add-DHCPServerInDC -DNSName $dc
        }

        "2" {
            # Config DNS
            $if_dns = Read-Host "Configurer un serveur DNS pour les clients ? (O pour Oui, N pour Non)"
            if ($if_dns -eq "O" -or $if_dns -eq "o") {
                $op_dns = Read-Host "Adresse IP du serveur DNS ? (ex: 192.168.1.250)"
                Set-DhcpServerv4OptionValue -DNSServer $op_dns
            } elseif ($if_dns -eq "N" -or $if_dns -eq "n") {
                Write-Output "Pas de serveur DNS"
            } else {
                Write-Warning "Erreur de choix !"
                f_choix_dhcp
                return
            }

            # Config passerelle
            $if_passerelle = Read-Host "Configurer une passerelle pour les clients ? (O pour Oui, N pour Non)"
            if ($if_passerelle -eq "O" -or $if_passerelle -eq "o") {
                $op_passerelle = Read-Host "Adresse de la passerelle ? (ex: 192.168.1.254)"
                Set-DhcpServerv4OptionValue -Router $op_passerelle
            } elseif ($if_passerelle -eq "N" -or $if_passerelle -eq "n") {
                Write-Output "Pas de passerelle"
            } else {
                Write-Warning "Erreur de choix !"
                f_choix_dhcp
                return
            }

            # Config domaine
            $if_domaine = Read-Host "Le serveur DHCP est-il dans un domaine ? (O pour Oui, N pour Non)"
            if ($if_domaine -eq "O" -or $if_domaine -eq "o") {
                $op_domaine = Read-Host "Le nom du domaine (ex: domaine.local)"
                Set-DhcpServerv4OptionValue -DNSDomain $op_domaine
            } elseif ($if_domaine -eq "N" -or $if_domaine -eq "n") {
                Write-Output "Pas de domaine"
            } else {
                Write-Warning "Erreur de choix !"
                f_choix_dhcp
                return
            }

            Restart-Service DhcpServer
        }

        "3" {
            $nom_plage = Read-Host "Donner un nom (ex: Plage-direction)"
            $description_plage = Read-Host "Donner une description de la plage"
            $ip_debut = Read-Host "Adresse IP de debut ? (ex: 192.168.1.1)"
            $ip_fin = Read-Host "Adresse IP de fin ? (ex: 192.168.1.254)"
            $masque = Read-Host "Masque reseau ? (ex: 255.255.255.0)"
            Add-DhcpServerv4Scope -Name $nom_plage -StartRange $ip_debut -EndRange $ip_fin -SubnetMask $masque -Description $description_plage
            Restart-Service DhcpServer
        }

        "4" {
            $nom_machine = Read-Host "Donner le nom de la machine (ex: CLIENT-10)"
            $mac_machine = Read-Host "Donner l'adresse MAC de la machine (ex: 00-0C-29-0D-EF-64)"
            $ip_reseau = Read-Host "Votre Adresse reseau ? (ex: 192.168.1.0)"
            $ip_reserve = Read-Host "Adresse IP reserve pour le client ? (ex: 192.168.1.20)"
            $description_reservation = Read-Host "Donner une description de la reservation"
            Add-DhcpServerv4Reservation -Name $nom_machine -ScopeId $ip_reseau -IPAddress $ip_reserve -ClientId $mac_machine -Description $description_reservation
            Restart-Service DhcpServer
        }

        "5" { exit }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    # Boucle vers le menu
    f_choix_dhcp
}

### PROGRAMME PRINCIPAL #################################################################


f_choix_dhcp