### FONCTION #############################################################################

function f_choix_dns {

    Write-Host "`n*** MENU GESTION DNS :" -BackgroundColor Blue -ForegroundColor White
    Write-Output "
    `n1 - Creer une zone de recherche directe (principale)
    `n2 - Creer une zone de recherche inversee (principale)
    `n3 - Creer une zone de recherche directe (secondaire)
    `n4 - Creer une zone de recherche inversee (secondaire)
    `n5 - Ajouter un enregistrement A et PTR 
    `n6 - Configurer une redirection
    `n7 - Ajouter un enregistrement NS (directe)
    `n8 - Ajouter un enregistrement NS (inversee)
    `n9 - Quitter `n"

    $choix = Read-Host "`n*** Que voulez-vous faire ?"

    switch ($choix) {

        "1" {
            $create_zone = Read-Host "`n*** Comment nommer la zone ? (ex: zone.lan)"
            Add-DnsServerPrimaryZone -Name $create_zone -ZoneFile "${create_zone}.dns" -DynamicUpdate None -PassThru
        }

        "2" {
            $addr_reseau = Read-Host "`n*** Adresse reseau ? (ex: 192.168.1.0/24)"
            $create_zone = Read-Host "`n*** Comment nommer la zone ? (ex: 1.168.192)"
            Add-DnsServerPrimaryZone -NetworkID $addr_reseau -ZoneFile "${create_zone}.in-addr.arpa.dns" -DynamicUpdate None -PassThru
        }

        "3" {
            $zone = Read-Host "`n*** Le nom de la zone ? (ex: zone.lan)"
            $srv_master = Read-Host "`n*** Adresse IP du serveur maitre ? (ex: 192.168.1.250)"
            Add-DnsServerSecondaryZone -Name $zone -ZoneFile "${zone}.lan.dns" -MasterServers $srv_master -PassThru
        }

        "4" {
            $addr_reseau = Read-Host "`n*** Adresse reseau ? (ex: 192.168.1.0/24)"
            $zone = Read-Host "`n*** Le nom de la zone ? (ex: 1.168.192)"
            $srv_master = Read-Host "`n*** IP du serveur maitre ? (ex: 192.168.1.250)"
            Add-DnsServerSecondaryZone -NetworkID $addr_reseau -ZoneFile "${zone}.in-addr.arpa.dns" -MasterServers $srv_master -PassThru
        }

        "5" {
            $zone = Read-Host "`n*** Le nom de la zone ? (ex: zone.lan)"
            $nom_machine = Read-Host "`n*** Le nom d'hote de la machine ? (ex: CLIENT-10)"
            $ip_machine = Read-Host "`n*** Adresse IP de la machine ? (ex: 192.168.1.20)"
            Add-DnsServerResourceRecordA -Name $nom_machine -ZoneName $zone -IPv4Address $ip_machine -TimeToLive 01:00:00 -CreatePtr -PassThru
        }

        "6" {
            $redirection = Read-Host "`n*** Adresse IP du serveur DNS de redirection ? (ex: 8.8.8.8)"
            Add-DnsServerForwarder -IPAddress $redirection -PassThru
        }

        "7" {
            $zone = Read-Host "`n*** Le nom de la zone ? (ex: zone.lan)"
            $nom_dns = Read-Host "`n*** Nom du serveur DNS a enregistrer ? (ex: SRV-DNS)"
            Add-DnsServerResourceRecord -Name "@" -NS -ZoneName $zone -NameServer "${nom_dns}.${zone}" -PassThru
        }

        "8" {
            $zone = Read-Host "`n*** Le nom de la zone ? (ex: 1.168.192)"
            $nom_dns = Read-Host "`n*** Nom du serveur DNS a enregistrer ? (ex: SRV-DNS)"
            Add-DnsServerResourceRecord -Name "@" -NS -ZoneName "${zone}.in-addr.arpa" -NameServer "${nom_dns}.${zone}" -PassThru
        }

        "9" {
            exit
        }

        default {
            Write-Warning "Erreur de choix !"
        }
    }

    f_choix_dns
}


### PROGRAMME PRINCIPAL #################################################################


f_choix_dns