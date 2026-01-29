### FONCTION #############################################################################

function f_choix_config {

    Write-Host "`n*** MENU CONFIGURATIONS SERVEUR :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Renommer le serveur (Le serveur redemarrera)
    `n2 - Renommer les cartes reseaux
    `n3 - Configurer les adresses IP
    `n4 - Joindre un domaine
    `n5 - Quitter `n"

    $choix = Read-Host "`n*** Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            $nom_srv = Read-Host "`n Comment renommer ce serveur ?"
            Rename-Computer -NewName $nom_srv
            Restart-Computer
        }

        "2" {
            Get-NetAdapter | Format-List Name, InterfaceIndex, MacAddress
            Get-NetIPConfiguration | Format-List InterfaceAlias, IPv4Address

            $choix_carte_reseau = Read-Host "`n*** Quelle carte voulez-vous renommer ?"
            $nom_carte_reseau   = Read-Host "`n*** Comment renommer la carte ?"

            Get-NetAdapter -Name $choix_carte_reseau |
                Rename-NetAdapter -NewName $nom_carte_reseau
        }

        "3" {
            Get-NetAdapter | Format-List Name, InterfaceIndex, MacAddress
            $choix_carte_reseau = Read-Host "`n*** Quelle carte voulez-vous configurer ?"
            $choix_config_reseau = Read-Host "`n*** Configurer la carte en DHCP ? (O/N)"

            if ($choix_config_reseau -match "^[Oo]$") {
                Set-NetIPInterface -InterfaceAlias $choix_carte_reseau -Dhcp Enabled
            }
            elseif ($choix_config_reseau -match "^[Nn]$") {

                $ip_adresse = Read-Host "`n*** Adresse IP ? (ex: 192.168.1.10)"
                $cidr       = Read-Host "`n*** Masque CIDR ? (ex: 24)"
                $choix_passerelle = Read-Host "`n*** Renseigner une passerelle ? (O/N)"

                if ($choix_passerelle -match "^[Nn]$") {
                    New-NetIPAddress -InterfaceAlias $choix_carte_reseau `
                                     -IPAddress $ip_adresse `
                                     -PrefixLength $cidr
                }
                elseif ($choix_passerelle -match "^[Oo]$") {
                    $passerelle = Read-Host "`n*** IP de la passerelle ? (ex: 192.168.1.254)"
                    New-NetIPAddress -InterfaceAlias $choix_carte_reseau `
                                     -IPAddress $ip_adresse `
                                     -PrefixLength $cidr `
                                     -DefaultGateway $passerelle
                }
                else {
                    Write-Warning "Erreur de choix !"
                }
            }
            else {
                Write-Warning "Erreur de choix !"
            }

            $choix_config_dns = Read-Host "`n*** Renseigner un serveur DNS ? (O/N)"

            if ($choix_config_dns -match "^[Oo]$") {
                $dns = Read-Host "`n*** Adresse IP du serveur DNS ? (ex: 8.8.8.8)"
                Set-DnsClientServerAddress -InterfaceAlias $choix_carte_reseau `
                                           -ServerAddresses $dns
            }
            elseif ($choix_config_dns -match "^[Nn]$") {
                Write-Output "Pas de configuration DNS"
            }
            else {
                Write-Warning "Erreur de choix !"
            }
        }

        "4" {
            $nom_domaine = Read-Host "`n*** Nom du domaine ? (ex: domaine.local)"
            $admin_user  = Read-Host "`n*** Compte administrateur ? (ex: admin@domaine.local)"
            Add-Computer -DomainName $nom_domaine -Credential $admin_user
        }

        "5" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    f_choix_config
}


### PROGRAMME PRINCIPAL #################################################################


f_choix_config