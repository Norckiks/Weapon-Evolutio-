# Weapon Evolution

Jeu Roblox de survie contre des zombies : progression en pièces/XP, armes, pets et zones à niveaux requis, avec interface cartoon.

Quatre zones, douze espèces : Ville (niv. 1), Usine (5), Laboratoire (12) et Port des cendres (20). Voir [docs/reference/ZONES.md](docs/reference/ZONES.md) pour les modèles, butins, portails et dépendances de scène.

Sur PC, M libère le pointeur pour cliquer sur l'interface ; M ou REPRENDRE ramène au combat. Les attaques sont suspendues tant que le pointeur est libre. Les menus et la réapparition réinitialisent ce mode.

Une flèche cartoon accompagne le déblocage d'une nouvelle zone : portail de destination au refuge, ou portail de retour si le joueur se trouve dans une autre zone. Elle disparaît à l'arrivée et se masque dans les menus.

Armes à feu achetables depuis l'interface : pistolet (niveau 3), SMG (niveau 7), revolver à six coups (niveau 12) et fusil à pompe à sept plombs (niveau 16). Leurs caractéristiques et limites vérifiées sont dans docs/reference/ARMES_A_FEU.md.

Les tirs de tête font ×1,5 dégâts, avec calcul serveur et récompenses ordinaires : [règles et tests](docs/reference/TIRS_A_LA_TETE.md).

Les zombies préparent leurs coups : direction verrouillée, esquive possible et interruption par étourdissement. Voir [les règles de combat ennemi](docs/reference/ZOMBIES_COMBAT.md).

La poursuite contourne les obstacles et reprend les trajets bloqués : [navigation zombies et mesures](docs/reference/NAVIGATION_ZOMBIES.md).

À partir du niveau 5, cinq capacités sont débloquées par niveau : onde de choc, frappe tellurique, lance cryo (tir droit jusqu'à 70 studs), égide astrale et second souffle. Le serveur vérifie niveau, endurance, délai, cibles, protection et soin. Voir [docs/reference/CAPACITES.md](docs/reference/CAPACITES.md).

Missions & dossiers propose trois objectifs permanents par zone, avec douze récompenses uniques en pièces et XP. Voir [docs/reference/EXPEDITIONS.md](docs/reference/EXPEDITIONS.md) pour les règles, le champ de profil et les preuves de test.

Refonte portrait des sept pages installée, validation complète encore en attente : [état et reprise des tests UI](docs/reference/UI_MOBILE.md).

Caisses d’armes et de pets en pièces : onglet CAISSES, probabilités visibles et ouverture 3D cartoon. Voir [docs/reference/CAISSES.md](docs/reference/CAISSES.md) pour les prix, règles et preuves.

Panneau de test personnel : F4 ou bouton ADMIN, réservé à Bruno_ban369. Voir [les commandes et limites](docs/reference/ADMIN_PANEL.md).

## Organisation du dépôt

- `studio/` : sources Luau et manifeste des scripts actifs.
- `docs/reference/` : guides fonctionnels et preuves.
- `docs/historique/` : anciennes analyses, idées et plans, sans preuve d’implémentation.
- `assets/` : ressources graphiques.
- [Index documentaire](docs/README.md) : chemin de reprise et choix du guide pertinent.

Pour reprendre le travail :

1. Lire [AGENTS.md](AGENTS.md), puis [RELAIS_IA.md](RELAIS_IA.md).

2. Utiliser [le mapping des scripts](studio/runtime-manifest.json) pour retrouver leurs instances Studio.

3. Consulter [les déplacements](docs/reference/MOUVEMENTS.md), [les armes à feu](docs/reference/ARMES_A_FEU.md) et [les images UI](assets/ui/README.md) selon le travail.

Prompt de relais :

> Lis AGENTS.md puis RELAIS_IA.md. Inspecte les sources locales et l'instance Roblox Studio avant de modifier quoi que ce soit. Continue les améliorations en priorité à partir des vérifications restantes. Garde les achats Robux désactivés et les achats en pièces disponibles depuis l'UI. Mets à jour les sources locales et le guide après tes changements, en séparant les tests effectués des limites restantes.

Les scripts seuls ne contiennent pas tous les modèles, terrains et objets GUI du fichier Roblox. Les modifications installées en Studio n'impliquent ni sauvegarde du fichier .rbxl ni publication.


