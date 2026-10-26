# Relais IA — état au 26 octobre 2026 (heure locale)

## Demande et état

L'utilisateur veut enrichir continuellement le jeu : UI cartoon animée, armes/animations distinctes, achats depuis les menus, déplacements inspirés d'Evade, images, nouvelles zones, capacités et progression rapide. Il insiste pour ajouter encore du contenu et garder un relais clair pour une autre IA. L'objectif général reste en cours ; les achats Robux restent désactivés.

État confirmé le 26 octobre 2026 : Studio Évolution des armes, placeId 78882167241715, connexion redécouverte 1810e323-f08c-4cee-af08-45d071dcc952. Play arrêté, mode Edit après le test de timeline. Aucune publication ni écriture de données de production pendant cette passe ; aucune sauvegarde .rbxl confirmée.

### Point de reprise actuel

Le lot le plus récent a uniquement réorganisé les documents : guides fonctionnels sous `docs/reference/`, intentions et analyses anciennes sous `docs/historique/`. Lire `docs/README.md` pour sélectionner le contexte utile ; les notes historiques ne sont pas une preuve de fonctionnalité. Aucun script, mapping, asset ou état Studio n'a été modifié. Studio a été redécouvert sous `78882167241715_AutoRecovery_0.rbxl` et était en Play pendant cette opération ; ne pas le traiter comme Edit.

Prochaine action de reprise du jeu inchangée : inspecter visuellement les poses de capacité en Play avec un personnage ayant accès aux capacités, puis contrôler ReducedMotion et les formats mobiles portrait/paysage. Consulter `docs/reference/CAPACITES.md` pour les preuves et limites précédentes.

## Lot du 26 octobre 2026 — organisation des fichiers documentaires

Déplacement sans modification de contenu des 11 guides vers `docs/reference/` et de six notes historiques vers `docs/historique/` ; le nom accentué `idéé a faire.txt` est normalisé en `idees-a-faire.txt`. Tous les renvois documentaires ont été mis à jour. Ajout de `docs/README.md` comme carte de navigation et mise à jour de `README.md` et `AGENTS.md`. Les sources Luau, le manifeste (46 scripts), les assets et le jeu Studio ne changent pas.

Preuve : inventaire local avant/après et recherche des anciennes références ; aucun test de jeu n'était nécessaire. Limite : Studio a été observé en Play et n'a pas été modifié. Aucune validation visuelle ou gameplay n'a été faite dans ce lot. Objectif général toujours en cours.

## Lot du 26 octobre 2026 — séquençage des poses de capacité

Demande : améliorer les animations en s'appuyant sur HyperFrames, Context7, Ponytail et ECC. `studio/WeaponMotion.luau` et ses consommateurs `FistsClient`/`CharacterCombat` ont été relus avant modification. Ces deux consommateurs gardent leurs couches Motor6D/AnimationConstraint et leur facteur ReducedMotion. HyperFrames disponible dans la session est un outil/skill de composition vidéo HTML, pas un runtime Roblox ; aucun média ou dépendance vidéo n'a été ajouté. Son idée de séquençage par phases (anticipation, frappe, retombée) inspire seulement la timeline Luau. Context7 a fourni la référence officielle Roblox sur PreSimulation et les transformations d'animation ; ECC motion-advanced cible React/Next.js et ne s'applique pas à Luau. Ponytail : réutilisation du contrôleur commun, sans script nouveau.

`studio/WeaponMotion.luau` et `ReplicatedStorage.WeaponMotion` modifiés : anticipation avec léger dépassement, frappe rapide, recul bref à l'impact et récupération adoucie sur Pulse et les quatre capacités (Slam, Frost, Aegis, SecondSouffle). Les touches, dégâts, délais serveur, effets et achats ne changent pas. FistsClient et CharacterCombat restent les seuls consommateurs concernés ; réductions de pose déjà appliquées dans ces deux callers préservées. La synchronisation a révélé que les deux fonctions d'easing manquaient dans Studio alors que le nouveau code les appelait : ajout des définitions manquantes en Edit. Sauvegarde préalable du module dans `ServerStorage.BeforeAbilityMotionArc` (clone de l'ancienne version).

Test Play réel du ModuleScript `ReplicatedStorage.WeaponMotion` : 826 échantillons, poids bornés [0,1], CFrame finis, angles de torse finis, frontières des phases sous 0,01 stud de déplacement. Résultat console `WEAPONMOTION_ARC_OK samples=826`. Play arrêté ; get_studio_state confirme Edit. Aucune erreur de module relevée ; une ligne de log réseau de l'UI assistant Roblox sans rapport avec le jeu était présente. `docs/reference/CAPACITES.md` et ce relais mis à jour. Pas de changement au manifeste runtime (46 scripts).

Limites : test numérique du module, pas de capture visuelle des poses en combat ni essai clavier/manette/tactile, mobile ou multijoueur. Le style HyperFrames n'est pas intégré au runtime ; c'est une transposition du principe de timing en CFrame Roblox. Aucune sauvegarde `.rbxl`, publication, transaction ou modification DataStore de production. Prochaine étape : inspecter les poses à l'écran en Play avec une capacité débloquée, sur personnage réel et en ReducedMotion, puis recadrer les amplitudes si nécessaire. L'objectif général reste en cours.

## Lot du 26 octobre 2026 — détails VFX et conflit de touche

Demande : ajouter des détails aux capacités et corriger le conflit de touche F signalé par l'utilisateur (F est déjà la lampe torche). Vérification préalable : scripts locaux et Studio comparés à l'identique, aucune autre occurrence de Aegis F en dehors de GameplayConfig/PulseClient ; Presentation.client.luau lie bien SurvivorFlashlight à F/DPadUp. Le raccourci H et le bouton R3 étaient libres dans les contrôles actifs.

`studio/Pulse.client.luau` et StarterPlayer.StarterPlayerScripts.PulseClient ajoutent un anneau givré qui s'écarte à l'impact de la Lance cryo, six cristaux pulsants soudés aux trois anneaux de l'Égide, une vague tellurique segmentée qui s'ouvre après les fissures, et un halo vert/or qui s'écarte sous le Second souffle. Chaque effet se nettoie via Debris ; ReducedMotion réduit les pièces et supprime leurs trajectoires. Pas de script runtime supplémentaire. `GameplayConfig.luau` affiche désormais H pour Égide ; le client la lie à H/R3. F continue de piloter la lampe. `docs/reference/CAPACITES.md` et `studio/qa/README.md` mis à jour. Manifeste : 46 scripts.

Backup Edit `ServerStorage.BeforeAbilityDetailsKey` contient GameplayConfig et PulseClient avant le changement de touche. Test de raccourcis en Play : HUD présent, Égide liée à H et R3, lampe toujours liée à F et DPadUp. Sonde synthétique d'événement `AbilityFX` pour Slam : 12 fissures et 12 segments de vague créés ; démarrage Play/chargement des scripts sans erreur de console observée. Le harnais gameplay SecondSouffle a aussi confirmé le soin, son délai serveur et la régénération d'endurance, puis a échoué sur la demande Slam. Le résultat ne constitue donc pas une passe complète des quatre capacités. Play arrêté ; Edit confirmé. La session utilisée était SessionStudio et a restauré les valeurs de profil après l'échec. Aucun achat, DataStore de production, publication ni sauvegarde .rbxl.

Limites : l'observateur client pour compter Frost/Aegis/SecondSouffle a perdu la connexion/timé out lors de la sonde multi-effets ; leurs nouveaux détails et les variantes ReducedMotion ne sont pas encore vérifiés en rendu. La capture viewport n'a pas été exploitable dans les passes précédentes. Pas de contrôle mobile physique, multijoueur ou périphérique réel. Prochaine étape : reprendre des sondes client séparées par capacité et inspecter une capture cadrée, puis vérifier le HUD mobile portrait/paysage. Ne pas marquer l'objectif général terminé.

## Lot du 26 octobre 2026 — Lance cryo, égide astrale et passe VFX

Demande : améliorer les animations/visuels, réparer Égide astrale et ajouter une attaque à distance. Sources locales et instances Studio lues/comparées, Play arrêté avant les changements ; backup Edit dans ServerStorage.BeforeAbilityRangeVisual (GameplayConfig, PulseAbility, PulseClient, WeaponMotion, puis SprintServer).

L'ex-cône « Sillage cryo » devient « Lance cryo » (R). Le client transmet la direction horizontale caméra ; PulseAbility valide un vecteur unitaire, choisit une seule cible jusqu'à 70 studs dans un couloir ±4,5 studs, vérifie les surfaces et conserve dégâts/étourdissement/endurance/délai côté serveur. SprintServer transmet cet argument sans le rendre autorité sur les dégâts. WeaponMotion prépare les bras puis fait un estoc. PulseClient affiche un projectile blanc-cyan, double traînée, marques de charge et éclats au point d'impact.

Le blocage de l'Égide était déjà contrôlé côté serveur dans ZombieMelee.CanHit au démarrage et à l'impact du coup. Le problème perceptible venait de huit grosses sphères superposées, pas d'une absence de garde dans le contrôleur. Les sphères sont remplacées par trois anneaux soudés, chacun formé de 12 segments (8 segments en ReducedMotion), qui suivent le personnage pendant la durée de protection. Frappe tellurique dessine 12 fissures qui s'étendent ; Second souffle fait monter 12 étincelles vert/or. Les états ReducedMotion gardent des effets statiques réduits.

Sources synchronisées : studio/GameplayConfig.luau, studio/PulseAbility.luau, studio/Sprint.server.luau (ServerScriptService.SprintServer), studio/Pulse.client.luau (StarterPlayer.StarterPlayerScripts.PulseClient), studio/WeaponMotion.luau. README.md et docs/reference/CAPACITES.md décrivent la Lance et les limites. Deux harnais QA temporaires ajoutés sous studio/qa (Abilities.server.luau, AbilityVisuals.server.luau) et procédure dans studio/qa/README.md ; aucun script runtime/manifeste ajouté, toujours 46 scripts.

Preuves Play SessionStudio : 16 assertions passent au total. Une vraie demande client a atteint une cible à 58 studs (100→70 PV), ignoré les cibles à 9 studs latéraux/72 studs de distance, consommé l'endurance et armé le délai. Le test de garde a observé GuardUntil, TryAttack refusé comme Guarded sans dommage, puis un coup normal accepté et dommage après les 3,2 s. Deuxième harnais : soin réel de 20 PV jusqu'au maximum ; frappe réelle à 34 dégâts et étourdissement. Côté Client : 2 trails et un projectile cryo plus 7 éclats ; 36 segments Égide (8 en ReducedMotion) ; 12 particules de soin ; 12 fissures ; 20 échantillons de pose ont retourné CFrame et poids borné. Résultats reproductibles décrits dans studio/qa/abilities-result.json. Console finale vide, les erreurs de syntaxe du premier essai ont été corrigées avant la passe réussie.

Limites : pas de fixture dédiée à l'obstacle mural pour le rayon cryo. Capture de gameplay inutilisable (image de chargement ou noir), donc les compteurs/mesures prouvent les instances et timelines, pas leur qualité à l'écran. Pas d'essai physique mobile/manette, multijoueur ou DataStore. Les deux scripts QA et toutes les fixtures ont disparu à l'arrêt de Play ; Edit confirmé, aucune sauvegarde .rbxl ni publication. Prochaine étape : inspection réelle du rendu et validation sur mobile portrait/paysage.

## Lot du 26 octobre 2026 — quatre nouvelles capacités animées

Demande : ajouter quatre capacités avec des animations plus poussées. Ponytail utilisé pour borner la portée ; Context7 `/roblox/creator-docs` consulté pour l'entrée tactile et les RemoteEvents. ECC `motion-advanced` lu mais non appliqué : sa portée déclarée est React/Next.js et exclut explicitement l'animation de jeu.

Quatre actions débloquées aux niveaux 8/12/16/20 : Frappe tellurique (E, zone, dégâts/repousse), Sillage cryo (R, cône, interruption), Égide astrale (F, bloque les coups de mêlée zombies 3,2 s) et Second souffle (G, soin plafonné à 35 % des PV max). L'onde Q/L1 reste compatible. En tactile, un bouton d'action et un chevron sélectionnent parmi les cinq ; sur manette, X/Y/B/A activent les quatre nouveautés.

Second souffle refuse également de consommer endurance/délai lorsque le joueur est déjà à PV max ; l'interface affiche « PV MAX ».

Fichiers synchronisés avec Studio : `studio/GameplayConfig.luau`, `studio/PulseAbility.luau`, `studio/Sprint.server.luau`, `studio/ZombieMelee.luau`, `studio/Pulse.client.luau`, `studio/WeaponMotion.luau`, `studio/CharacterCombat.client.luau`, `studio/FistsClient.client.luau` et `studio/ZoneGuide.client.luau`. README et docs/reference/CAPACITES.md mis à jour. Pas de nouveau script actif ni d'entrée manifeste ; 46 scripts restent référencés. Backup Edit dans `ServerStorage.BeforeFourAbilities` (9 scripts), aucune scène reconstruite.

Vérification Play : scripts chargés, console vide après correction d'un défaut de placement des boutons. Les timelines des cinq actions ont renvoyé CFrame/poids valides. Le HUD PC affichait les cinq boutons en 1447×801, avec les quatre boutons de capacités à des coordonnées distinctes. Quatre événements AbilityFX synthétiques ont produit les quatre libellés attendus, également avec ReducedMotion ; la bulle de l'Égide suivait le personnage via soudure. Quatre demandes client réelles à niveau 1, refuge et avant démarrage ont été refusées sans changement : endurance 100, PV 100, délai Slam 0 avant/après. Les préparations locales du HUD ont été restaurées ; Play arrêté, Edit confirmé.

Limites : pas d'activation réussie avec personnage débloqué, donc dégâts, soin et garde non éprouvés en combat réel. Pas de capture viewport exploitable (l'outil a renvoyé l'image de chargement), test clavier/manette/tactile physique, formats mobiles portrait/paysage ou multijoueur. Aucun profil/DataStore de production, achat Robux, publication ou sauvegarde `.rbxl` touchés. Prochaine étape : tester les quatre usages dans une expédition sur personnage de test niveau 20, puis contrôler le HUD mobile dans les deux orientations.

## Lot du 26 octobre 2026 — onde violette avec charge et explosion

Nouvelle demande : teinter l'écran en violet, ajouter des marques au sol, faire charger puis exploser la vague et la vérifier en Play. Ponytail appliqué (portée minimale), Context7 /roblox/creator-docs consulté pour ColorCorrectionEffect local au CurrentCamera.

`studio/Pulse.client.luau` et son instance StarterPlayer.StarterPlayerScripts.PulseClient synchronisées : effet entièrement client sur l'événement serveur accepté ; ColorCorrectionEffect violet uniquement sur la caméra locale, anneau de marques néon au sol qui se resserre, noyau qui charge, puis 24 segments violets et 18 magenta qui s'étendent au rayon, noyau d'explosion, BOUM et son à l'impact. Les composants temporaires sont non-collidables et nettoyés. ReducedMotion : charge .16 s, teinte atténuée, 8 marques fixes et 6 éclats fixes. `studio/WeaponMotion.luau` et ReplicatedStorage.WeaponMotion : les bras suivent la charge .42 s, l'impact puis une récupération .36 s ; les deux consommateurs (FistsClient et CharacterCombat) réutilisent cette timeline.

Backup Studio `ServerStorage.BeforePulseCharge`. Test Play : scripts chargés, console vide aux vérifications finales ; événement `PulseFX` injecté visuellement au spawn (pas de dégâts, achat ou mutation de profil). Capture inspectée au stade charge : cercle de marques visible et teinte violette. Échantillonnage client normal : 16 marques à .2 s ; à .5 s, teinte RGB normalisée .53/.27/.87, 42 éclats, noyau d'explosion et texte BOUM visible ; texte en fondu à .7 s. ReducedMotion : 8 marques et 6 éclats fixes, teinte RGB .91/.86/1 puis neutre à .32 s, aucun flash d'impact, attribut local restauré. Une première passe réduite avait un flash trop intense ; corrigé, puis retesté. La caméra de test a été cadrée vers le sol ; Play arrêté et mode Edit confirmé. Aucun screenshot enregistré sur disque.

Limites : personnage niveau 1 au refuge, donc test visuel synthétique par PulseFX, pas activation Q réelle ni validation des règles de combat ; pas de toucher physique, autre appareil ou multijoueur. Aucun changement serveur/économie, DataStore, publication ou sauvegarde .rbxl. Prochaine étape : tester l'activation Q dans une expédition sur un personnage de test niveau 5+ si nécessaire, puis inspecter les proportions en mobile paysage et portrait.

## Lot du 26 octobre 2026 — animation de l'onde de choc

Demande : améliorer l'animation de la capacité onde de choc. Sources locales et instances Studio PulseClient/WeaponMotion consultées avant changement. Studio redécouvert comme 78882167241715_AutoRecovery_0.rbxl, Edit actif ; sauvegarde préalable des deux instances dans ServerStorage.BeforePulsePolish.

`studio/Pulse.client.luau` ajoute une couronne cyan de 16 segments et un écho doré retardé de 12 segments, la poussée s'étend jusqu'au rayon avec fondu/réduction de largeur, et le texte BOUM surgit en hauteur/échelle puis disparaît. Mode ReducedMotion conserve six segments fixes et aucun écho. `studio/WeaponMotion.luau` donne à la pose une anticipation, un impact rapide et une récupération plus longue, partagée par les bras vue subjective et la couche de personnage. Changements installés en Studio Edit dans PulseClient et WeaponMotion après backup ; règles de combat et économie inchangées. Aucune entrée runtime/manifeste ajoutée.

docs/reference/CAPACITES.md mis à jour. Limites : pas de Play, compilation, capture visuelle ou mesure de rendu après cette passe ; les mesures déjà présentes dans docs/reference/CAPACITES.md décrivent la version précédente. Vérifier ensuite l'aspect sur PC et mobile et l'option ReducedMotion, puis ajuster si nécessaire. Mode Edit confirmé après installation ; aucune sauvegarde .rbxl ni publication effectuée. Ponytail utilisé pour borner la portée et réutiliser les scripts existants ; Context7 consulté pour la réduction des mouvements Roblox. ECC/Plugin Ponytail directement exposé non détecté dans les outils de session ; applicable ECC review frontend exclu car il cible React, pas Luau.

## Lot du 26 octobre 2026 — panneau admin personnel

Demande utilisateur : s'attribuer niveaux, armes, pets et monnaie pour tester, accès réservé à lui. Compte Studio identifié via StudioService:GetUserId puis Players:GetNameFromUserIdAsync : Bruno_ban369, **10565455042**. Lire docs/reference/ADMIN_PANEL.md pour l'utilisation et les limites.

Nouveau studio/AdminService.luau → ServerScriptService.AdminService. EconomyService initialise le module ; GameHub réutilise ses composants pour un panneau F4/ADMIN, quantité et six catégories. GameMenuOpen intègre AdminPanelOpen pour bloquer les attaques/libérer la souris. Autorité serveur à chaque requête, UserId unique sans bypass Studio/créateur/groupe, validation stricte des nombres/identifiants/plafonds, délai 0,3 s. Aucun paramètre cible. AdminAccess ne sert qu'à l'affichage. Armes/pets ajoutés sans changer l'équipement. Niveaux additionnels sans effacer XP. Gains Studio temporaires ; en production, autosave/sortie existantes, attributions bloquées si PersistenceMode n'est pas Saved. Reçus et autres champs conservés ; aucun paiement activé ni nouveau DataStore.

Comparaison préalable exacte EconomyService/GameHub : identiques aux sources locales. Backups ServerStorage.BeforeAdminPanel (2). Manifeste et AGENTS : **46 scripts actifs**. README et docs/reference/ADMIN_PANEL.md ajoutent l'aide. Aucun constructeur de scène exécuté.

Preuves : studio/qa/Admin.server.luau et admin-result.json, **29 contrôles serveur réussis**, profil restauré. Première fixture échouée sur création Player (capacité WritePlayer) ; refus d'identité étrangère finalement testé avec table synthétique, pas avec un autre client réel. Quantités invalides, catalogue, rate limit, plafonds, gains exacts et conservation équipement/reçus vérifiés. Client réel : F4 ouvre/ferme, verrou menu actif, clic pièces 0→1000, changement de catégorie jusqu'à ARMES ; appels AdminAction client réels pour niveaux/XP/arme/pet/fragments acceptés. Captures PC 1447×801 et téléphone 401×778/750×381 inspectées ; fenêtres et boutons mesurés, voir docs/reference/ADMIN_PANEL.md. Bouton déplacé en bas après chevauchement du HUD observé, placement final inspecté en portrait. Pas de capture enregistrée sur disque dans ce lot.

Limites : essais de clic souris en émulation mobile sans activation, donc pas de validation tactile revendiquée ; clavier virtuel, deuxième joueur, reconnexion/DataStore production non testés. Le refus d'accès en cas de sauvegarde indisponible est une garde lue dans le code, pas un scénario de production joué. Les contrôles serveur précèdent le dernier ajustement de position du bouton, qui ne modifie aucune logique économique. Les fixtures de pointeur/QA restent temporaires et ont disparu à l'arrêt Play. Console produit vide lors du dernier contrôle Play ; erreurs d'outillage/fixture décrites ci-dessus.

Context7 /roblox/creator-docs consulté sur validation des remotes ; ECC security-review et Ponytail appliqués. Pas de dépendance ni délégation. Play arrêté, simulateur default/LandscapeLeft. Aucune sauvegarde .rbxl ou publication effectuée. L'objectif général reste en cours. Prochaine étape : retour utilisateur sur le panneau et validation tactile physique des commandes/clavier.


## Lot du 26 octobre 2026 — caisses d'armes et de pets

Lire docs/reference/CAISSES.md et studio/qa/crates-result.json. Trois caisses en pièces : récupération 450/niv.5, arsenal 3500/niv.16, pets 800/niv.1. Probabilités individuelles affichées avant confirmation, identiques au tirage serveur ; doublon arme recyclé en 25 % du prix direct arrondi, doublon pet +1 copie. Aucun remplacement automatique de l'équipement, aucun nouveau schéma de profil/reçu. Robux toujours désactivés.

Deux nouveaux ModuleScripts ReplicatedStorage.CrateCatalog et CrateReveal. EconomyService et GameHub modifiés, anciens dans ServerStorage.BeforeCrates (2). Manifeste/AGENTS : **45 scripts actifs**. Nouvel onglet CAISSES et disposition portrait 4+4. CrateReveal.PetModel reçoit le constructeur existant de GameHub ; WeaponVisuals réutilisé. L'animation seule ne décide jamais d'une récompense.

PolicyService serveur à la connexion, autorisation seulement si ArePaidRandomItemsRestricted == false ; erreur/réponse inconnue/restriction bloque les caisses, achats directs conservés. Cache de session sans relance après erreur ; rejoindre une autre session pour réessayer. Garde anticipant les futurs packs de pièces Robux, dont l'activation reste non autorisée.

**39 contrôles économiques passés** avec vrais services et vrai remote client, plus **deux gardes de politique isolées** (pas deux profils géolocalisés réels). 100 tickets de chacun des trois pools vérifiés : 13 résultats. Débits, niveau/fonds/démarrage, doublons, capacité pets, bonus normal, équipement conservé, délai quatre secondes et paramètres falsifiés ignorés. Pas de couverture statistique ni de sauvegarde production revendiquée.

Achat PC natif : 20000→19550, tuyau. Portrait : 19550→18750, Mini Rôdeur. Paysage : 18750→18337, recyclage tuyau +37. Animation finale 79 images, couvercle Y relatif 0,94→1,694/115° puis modèle. Prototype initial descendait ; corrigé. Mode réduit/muet : révélation directe, zéro image de coffre animé, aucun son. Passer : clic vers 0,736s, résultat observé 0,784s avant automatique 1,3s, sans autre achat.

Captures inspectées et enregistrées dans studio/qa/screenshots/crate-*.png. Caméra réelle PC 1447×801 et iPhone 17 Pro 401×778/750×381 ; titres/probabilités TextFits=true, actions ~44,22/~44,12 unités. Entrées mobiles simulées par souris après observation des coordonnées InputBegan ; pas de tactile physique. Les huit onglets sont visibles, mais les sept anciennes pages restent partiellement vérifiées selon docs/reference/UI_MOBILE.md.

Une fixture QA a d'abord échoué sur la capacité Source d'un Script ordinaire ; corrigée en préparant les copies avec MCP en Server Play, puis en les requérant dans un vrai Script. Des sondes GUI trop précoces ont aussi échoué avant activation réelle. Ne pas annoncer la console entièrement vide de ce lot ; pas d'erreur produit observée pendant les ouvertures finales.

État final audité : nouvelle connexion 1810e323-f08c-4cee-af08-45d071dcc952, 78882167241715_AutoRecovery_0.rbxl ; Play arrêté, Edit, simulateur default/LandscapeLeft, **45/45 synchronisés et compilants**, aucun QA/non répertorié en Edit. Profils temporaires restaurés, aucune publication ni sauvegarde .rbxl confirmée. Context7 officiel consulté, ECC verification-loop et Ponytail appliqués, pas de dépendance ni délégation. Pas de multijoueur, matériel physique, audition, équilibrage long ou reconnexion de production. Objectif général actif ; prochaines étapes : retours utilisateur sur les caisses, validation des autres pages, puis les autres améliorations.


## Correctif du 26 octobre 2026 — orientation des armes de mêlée

Demande précisée par l’utilisateur : les mains sont correctes ; ce sont les armes, notamment le Tuyau de récupération, qui s’animent à l’envers. Ne pas inverser globalement WeaponMotion ni modifier les poings ou le recul des armes à feu sur la base de cette demande.

Défaut reproduit en Play avec un vrai clic : l’axe longitudinal du tuyau, exprimé dans la caméra, pointe vers le joueur à l’impact (composante avant environ −0,502). Les modèles de mêlée s’étendent le long de +Y, tandis que la trajectoire était appliquée telle quelle aux mains et aux armes.

Un seul script actif modifié : studio/FistsClient.client.luau → StarterPlayer.StarterPlayerScripts.FistsClient. La rotation d’attaque de l’arme de mêlée inverse ses axes de tangage/lacet par conjugaison, sans changer la trajectoire des mains. Le point de prise conserve sa position exacte ; seule l’orientation de l’arme est corrigée. La pose Pulse reste composée séparément, la réduction des mouvements demeure appliquée. WeaponMotion, CharacterCombat, WeaponVisuals, EconomyService et les serveurs n’ont pas été modifiés. Comparaison exacte avant remplacement ; copie originale dans ServerStorage.BeforeMeleeWeaponOrientation.FistsClient.

Preuves : studio/qa/weapon-orientation-result.json. Seize séries de mesures dans un vrai client rendu, toutes passées : cinq armes de mêlée × normal/réduit (combos 1, 2 et 3 observés), quatre armes à feu normales, puis tuyau iPhone 17 Pro paysage 750×381 et portrait 401×778. Entrées natives souris sur PC, ButtonR2 simulé sur mobile. Aux événements d’impact acceptés, l’axe des armes de mêlée pointe vers l’avant. Tuyau PC normal environ 0,915 à 0,926. Écart maximal poignée/main <0,000016 stud ; orientation des armes à feu par rapport à leur ancienne formule <0,0007 rad (tolérance numérique, pas une variation recherchée).

Capture inspectée et enregistrée : studio/qa/screenshots/pipe-impact-portrait.png. Elle fige uniquement le viewmodel d’une vraie attaque observée vers 0,202 s ; axe avant 0,915. Ce gel est une fixture QA retirée, pas un comportement du jeu. La première tentative de capture PC avait figé le repos : exclue des preuves d’impact. La caméra PC/mobile était bien non nulle dans ce lot ; l’ancien problème de capture 1×1 n’empêche donc plus les tests actuels. Cela ne valide pas rétroactivement les sept pages UI.

QA réutilisables, jamais à installer en Edit : studio/qa/WeaponOrientationSetup.server.luau (profil SessionStudio temporaire, Equip/Restore via BindableFunction) et WeaponOrientation.client.luau (mesures après rendu déclenchées par vraies entrées). Les seize résultats ont aussi été contrôlés ensemble : tous les combos de mêlée présents, erreurs de prise <0,001 et erreurs angulaires des armes à feu <0,001 rad. Aucun compteur de couverture de code revendiqué.

État final : Play arrêté, simulateur default/LandscapeLeft, profils/options temporaires restaurés, console Play vide. Audit 43/43 sources et classes synchronisées, 43 compilations, aucun script non répertorié ou QA en Edit. Aucun achat Robux activé, aucun prix/profil/reçu/dégât modifié, aucune publication ni sauvegarde .rbxl confirmée. Pas de tactile/manette physiques, multijoueur, audition ou DataStore de production testés. Le corps en troisième personne est inchangé et n’est pas validé par ce correctif limité à la demande précisée.

Context7 : documentation officielle CFrame/joints consultée ; ECC verification-loop adapté aux vérifications Luau/rendu, Ponytail appliqué avec un seul changement de script actif. Pas de dépendance ni délégation ajoutée. Objectif général toujours en cours ; prochaine étape : poursuivre la validation docs/reference/UI_MOBILE.md maintenant qu’une vraie vue client est disponible, puis les autres améliorations demandées.


Retour utilisateur confirmé le 23 octobre : « La carte s’affiche normalement » lorsqu’il lance Jouer. Ne pas traiter l’ancien fond noir des captures comme un défaut visuel confirmé du jeu et ne pas modifier l’éclairage pour le compenser. Contrôle de reprise : même instance Studio redécouverte, mode Edit, Play arrêté. Ce retour ne valide pas les sept pages UI ni les animations ; les vérifications visuelles finales restent à faire. Aucun script ou objet de scène modifié pour ce retour.

Les 43 scripts correspondent aux fichiers locaux après normalisation des fins de ligne/espaces de bord et du commentaire PlayerCurrency ; tous compilent. Référence : studio/qa/handoff-audit-latest.json. Le manifeste couvre les 43 scripts actifs ; aucun script manquant/non répertorié. Les anciens audits datés sont historiques.

Dernier lot : **navigation zombies plus continue et reprise des trajets bloqués**. Lire docs/reference/NAVIGATION_ZOMBIES.md / studio/qa/zombie-navigation-result.json. Nouveau ModuleScript ServerScriptService.ZombieNavigation, ZombieDirector modifié ; ancien directeur dans ServerStorage.BeforeZombieNavigation. Manifeste/AGENTS : 43 scripts actifs. Aucun prix, profil, reçu, zone ou schéma DataStore modifié ; Robux désactivé, aucun constructeur permanent de scène exécuté.

Défaut reproduit sur un vrai colosse : points de chemin au sol, centre du rig 4,05 studs au-dessus ; le test 3D avec seuil 3 empêchait le passage au point suivant et causait des pauses répétées. Nouvelle progression horizontale avec tolérance verticale adaptée. Sur la même arène temporaire/mur/cible immobile, avant 12,03 s dont 4,25 s de pauses ; après 7,76 s dont 0,43 s. Une comparaison contrôlée, pas un benchmark FPS ou une garantie toutes zones. Mesure avant le dernier correctif de Destroy uniquement, qui ne change pas le suivi du chemin.

Deux calculs natifs simultanés au plus dans le module, file configurée 64, un travail par contrôleur. But en file actualisé sans doublon ; déplacement de cible >=6 studs invalide les anciens résultats. Les ComputeAsync démarrés ne sont pas prétendus annulés : un jeton refuse leur retour tardif. Pause/mort/retrait, combat préparé, étourdissement et retour au point d'origine nettoient les routes/connexions. Un calcul en attente n'est pas un blocage physique. NoPath arrête l'agent et temporise les essais (1,4 s), sans téléportation de rattrapage.

Immobilité 1,2 s : trajet forcé même si la tête voit par-dessus un obstacle bas ; vrais points de saut Humanoid. Le contrôleur garde ce trajet jusqu'à la fin. Path.Blocked est connecté pour les points devant l'agent ; **ce signal n'a pas été observé**, même pendant une observation ciblée de huit secondes sans repli physique. La reprise par immobilité a, elle, physiquement contourné le mur ajouté. Ne pas présenter la connexion d'événement comme une preuve d'émission.

Autre défaut reproduit : Destroy retirait le contrôleur mais laissait le MoveTo courant ; 5,60 studs parcourus en 0,8 s. Correction de l'arrêt du déplacement vivant. Validation finale : environ 0,122 stud de décélération après Pause et Destroy. Sans annuler les poussées physiques extérieures.

Preuves finales : **23 contrôles navigation +47 mêlée +29 Pulse =99**, tous passés sur la source finale. Parcours comparatif et anciennes passes exclus de ce total. Vrais calculs moteur et clones en physique serveur : chemin direct sans calcul, deux travailleurs/quatre en file observés, trois résultats obsolètes refusés, but remplacé, pauses/teardown, barrière basse franchie avec saut réel (~130,12 de hauteur racine sur sol Y120), mur ajouté contourné en ~12,02 s/deux révisions/une reprise, destination impossible temporisée. Running/Queued zéro à la fin du harnais navigation, Failed=1 correspond au NoPath volontaire. Le cap 64 n'est pas une charge 64 agents mesurée.

Mêlée/onde : esquives/annulations, vrai directeur, respawn réel et attribution ordinaire après vraie mort repassés. Caméra client encore 1×1, pose Pulse mesurée 0 ; ses anciens intitulés « renders » ne prouvent que les instances créées. Pas de capture/entrée physique, multijoueur, audition, benchmark, charge de foule, étage complexe ou production vérifiés. Boutiques/contours/poses restent à reprendre selon docs/reference/UI_MOBILE.md.

**Attention require :** une lecture Stats directement via execute_luau a montré un cache séparé à zéro ; elle n'est pas retenue comme état du jeu. Utiliser les Scripts serveur ordinaires temporaires des QA pour toute mesure de service. Les résultats ci-dessus viennent de ces Scripts. Ne pas recréer Label=Before avec le nouveau directeur et appeler cela une ancienne référence ; la baseline est historique et l'ancien code est sauvegardé.

Profils/positions restaurés, Play arrêté, default/LandscapeLeft, console finale Play vide, aucun QA en Edit. Audit final 43/43 synchronisés et compilants. Aucune publication/sauvegarde .rbxl confirmée. Context7 consulté sur pathfinding/Blocked ; workflow Codex on Crack direct inchangé sans rôle délégué. L'objectif général reste actif. La question asynchrone sur l'onglet client visible demeure sans réponse ; ne pas la dupliquer. Prochaine étape : vraie vue client pour les UI/poses, exploration terrain/foule et autres fonctionnalités.

Lot précédent : **préparation des attaques zombies et esquive directionnelle**. Lire docs/reference/ZOMBIES_COMBAT.md / studio/qa/zombie-melee-result.json. Les attaques instantanées après 0,18 s sont remplacées par préparation propre à chaque espèce (0,28 à 1 s), impact unique puis récupération. Le zombie s'arrête, verrouille sa direction et expose un contour orange/or pendant la préparation ; passer derrière lui ou hors portée évite le coup. Arc 100° total, portée 4,4 au départ/4,7 à l'impact. Délai entre débuts au moins 1,5 s et préparation+récupération. Les dégâts, récompenses, zones et slots restent ordinaires.

Nouveau ModuleScript ServerScriptService.ZombieMelee (studio/ZombieMelee.luau). Quatre scripts précédents modifiés : WorldConfig (durées des douze espèces), ZombieDirector (contrôleur par NPC), NPCPresentation (sons de préparation/geste), PresentationClient (poses synchronisées et Motor6D/AnimationConstraint). Copies dans ServerStorage.BeforeZombieWindups (4). Manifeste/AGENTS mis à 42 scripts. Aucun constructeur de carte, prix, reçu, schéma de profil ou DataStore modifié. Robux désactivé.

Jetons d'annulation et écoute StunnedUntil invalident tout coup préparé : même si l'étourdissement expire avant l'ancien impact, ce coup ne revient pas. Mort/retrait du NPC et remplacement du personnage invalidés ; zone/niveau, portée, cône et mur revérifiés. Les joueurs avant Jouer ne sont pas ciblés ; les menus en partie ne mettent pas le monde en pause. Highlight AttackWarning activé seulement en Windup, profondeur Occluded. Attributs AttackAt/AttackWindup/AttackRecovery/AttackFacing/AttackPhase/AttackOutcome synchronisent l'animation. ReducedMotion atténue les poses à 25 %. Sons de tissu existants via WorldFoley, arrêt de la préparation à annulation et nettoyage Ended/Debris.

Un défaut réel d'occlusion a été identifié : les cheveux Pink Hair.Handle du joueur dépassaient devant le mur et faisaient accepter une attaque malgré le corps protégé. HasSight exclut maintenant les accessoires/outils de la victime avant de chercher le corps ou le mur. Déclencheurs non solides traversés sous limite 32 ; murs solides transparents bloquants. Cette même fonction sert à la poursuite directe. La première assertion synthétique a ensuite été stabilisée en isolant l'accessoire sous un dossier du personnage et en plaçant le mur avant les membres ; le rayon brut doit toucher cet accessoire et le rayon filtré doit ensuite être bloqué par le mur. Ne pas confondre correction produit et montage de test.

Preuves : **47 contrôles complets mêlée + 29 régressions Pulse =76**, tous passés. Douze vrais rigs en contrôleurs isolés, délai minimal/dégât unique par espèce, récupération/cooldown, esquives préparées, murs/accessoires, étourdissement court, mort/retrait, accès, vrai directeur et vraie réapparition. Un vrai NPC du directeur a manqué une esquive puis annulé une attaque interrompue. Les 23 contrôles ciblés préalables ne s'ajoutent pas au total. Les déplacements d'esquive sont préparés par le serveur avec racines ancrées, pas une entrée clavier/tactile physique.

Pulse : vrai remote/endurance/délai, vraie mort Civilian (+8 pièces/+20 XP), Runner arrêté puis repris, poussée ~2,58 studs, respawn et maximum douze cibles. Les intitulés historiques « renders » de ses tests désignent ici des instances : 12/6 traits et 1/0 son créés, PoseDistance=0, caméra 1×1. **Aucun rendu des contours/poses/boutiques ni audition validé dans cette passe.** Les impacts mesurés n'étaient jamais précoces ; un Stalker a toutefois touché vers 0,439 s pour 0,28 configuré. Aucun délai maximal, benchmark FPS ou équilibre long revendiqué.

Profils/positions temporaires restaurés, fixtures retirées par arrêt Play. Console finale Play vide, audit final 42/42 synchronisés et compilants, simulateur default/LandscapeLeft. Aucun QA actif en Edit, aucune publication/sauvegarde .rbxl confirmée, pas de multijoueur, matériel tactile/manette, audition ou production. Context7 consulté sur délais/validation ; workflow Codex on Crack direct inchangé, aucun rôle délégué. L'objectif général reste actif.

Prochaine étape : vérifier une vraie vue client pour docs/reference/UI_MOBILE.md et les nouvelles poses/contours en PC/mobile/ReducedMotion ; puis continuer les capacités/événements/contenu. La question asynchrone sur l'onglet visible reste sans réponse, ne pas la dupliquer. Ne pas modifier l'éclairage pour compenser une capture noire. Le module de mêlée permet de tester la logique sans rendu, ce qui n'est pas une preuve visuelle.

Lot précédent : **tirs de tête ×1,5 et impacts cartoon plus doux**. Voir docs/reference/TIRS_A_LA_TETE.md / studio/qa/headshots-result.json. Le contrôle UI restait empêché par la caméra client 1×1, donc cette passe a ajouté une mécanique vérifiable par vrais remotes sans dépendre du rendu. Ne pas marquer les boutiques portrait validées.

Cinq sources et instances modifiées : GameplayConfig, FirearmBallistics, FirearmsServer, FistsClient, GameHub. Copies précédentes dans ServerStorage.BeforeHeadshots (5). Toujours 41 scripts actifs, manifeste inchangé. Aucun constructeur de scène, schéma DataStore, reçu ou prix modifié ; Robux désactivé. La note d'armurerie rappelle tête x1.5 ; ce texte a été installé/compilé après les essais de combat et doit être inclus dans la reprise visuelle.

Dégâts tête : pistolet 36, SMG 21, revolver 108, fusil 30/plomb (210 si sept têtes). Corps 24/14/72/20 inchangés. Seuls Head directement sous le modèle cible et le VisualHead canonique interrogeable donnent le bonus. Le serveur calcule montants et indicateurs depuis ses raycasts ; le client n'envoie toujours qu'une direction. Un tir mixte regroupe les montants par cible avant une seule application et une seule confirmation. Murs, portée, niveau/zone, cadence, recharges et attribution habituelle restent en vigueur. Aucun multiplicateur de récompense pour la tête.

PunchHit a un cinquième argument facultatif Headshot ; quatre arguments de mêlée restent compatibles. FistsClient affiche TETE!, garde la teinte de coup fort et le total. ReducedMotion désactive rotation/grossissement élastique/montée de la bulle et passe à quatre traits fixes, puis fondu, pour tous les coups. Vue <140×110 : pas de création de bulle pour éviter un clamp invalide ; dégâts serveur conservés. **Effets rendus non vérifiés dans cette passe**, seulement code compilé et confirmations reçues côté client.

Preuves : **93 contrôles passés (33 Firearms + 30 Shotgun corps + 30 Headshots)**. Montant/critique falsifiés ignorés, tête historique et visible, accessoire refusé comme tête, 21/108/210 exacts, mélange un plomb tête + deux corps =70, murs transparents solides et mauvaise zone bloqués. Les douze têtes des vrais templates 3D ont été visées via Shoot:FireServer sur clones ancrés hors IA ; un vrai Civilian du directeur, 35 PV, a ensuite été tué par un pistolet à 36 : +8 pièces/+20 XP une seule fois et une confirmation. Le pont client enregistre les véritables PunchHit. Le volume 4×4 du harnais Shotgun a été renommé Head → Torso pour expliciter sa régression corps historique ; les nouveaux tests couvrent séparément l'anatomie.

Fixtures retirées par arrêt de Play, profils restaurés ; console finale Play vide. Caméra restée 1×1 sur preset iphone_17_pro, aucune capture/entrée physique tentée comme preuve. Pas de multijoueur, tactile/manette physique, audition, benchmark, équilibre long ou persistance/reconnexion de production. Audit final 41/41 synchronisés et compilants, Play arrêté, default/LandscapeLeft. Aucune publication ni sauvegarde .rbxl confirmée. Context7 consulté sur raycast/validation serveur ; workflow Codex on Crack direct avec configuration précédente inchangée, pas de rôle délégué. L'objectif général reste actif.

Prochaine action : vérifier si le client rend une vraie vue et finir docs/reference/UI_MOBILE.md (sept pages, achats, rotation, dernière ligne, nouvelle note et bulle), puis continuer capacités/événements/contenu. La question asynchrone précédente sur l'onglet visible n'a pas reçu de réponse pendant cette passe ; ne pas en créer une seconde pour la même information. Ne pas modifier l'éclairage pour l'ancien fond noir, l'utilisateur avait confirmé la carte normale.

Lot précédent : **refonte portrait des sept pages — installée, validation incomplète**. Lire docs/reference/UI_MOBILE.md et studio/qa/portrait-catalog-result.json avant d'annoncer les boutiques validées. Un script actif modifié : GameHub ; version initiale dans ServerStorage.BeforePortraitCatalog.GameHub. Sources et instance synchronisées, 41 scripts inchangés en nombre. Aucun changement de prix, contrôles serveur, profils, reçus ou DataStore ; Robux désactivé.

Implémenté : fenêtre haute pour les sept pages, onglets en deux lignes 4+3, fermeture/actions arrondies au supérieur pour viser au moins 44 unités UI en portrait, cartes et textes agrandis, boutons pleine largeur, fusion/équipement pets côte à côte, aperçu arme 128×128 logique. Missions garde les cartes compactes. Pied de page élargi, minimum de texte corrigé ; disposition PC/paysage restaurée dans layoutWindow. Boutons désactivés non actifs/non sélectionnables. Défilement remis en haut au changement de page, position bornée conservée au rafraîchissement, génération protégeant les restaurations différées. Tailles caméra <100×100 ignorées en attendant la première vue.

Preuves partielles : Jouer activé à la souris depuis HasStarted=false, serveur ensuite true / InGameMenu=false sans fixture serveur modifiant le démarrage (avant les ultimes corrections du footer/garde caméra). Premier clic avec correction d'origine avait ouvert Options ; les centres absolus bruts ont ensuite fermé Options et activé Jouer. Ne pas généraliser la formule mobile des anciens lots. Atelier mesuré sur un vrai viewport iPhone 17 Pro 401×778 : textes/onglets/actions dans les limites après correction temporaire du minimum de texte du footer, ensuite persistée. Arrondi fermeture <44 et footer corrigés. **Pas une preuve de sept pages ni du rendu final intégral.**

Correction de libellé du lot précédent : la recherche `iphone%s*(%d+)` ignorait les espaces insécables des noms récents et sélectionnait iphone_7. Les mesures du fusil 666×374 / 374×666 étaient donc sur iPhone 7. shotgun-result.json et docs/reference/ARMES_A_FEU.md corrigés ; ne pas changer les autres rapports historiques sans preuve de leur preset. Dans cette passe, GetDeviceAsync a confirmé iphone_17_pro et sa vue 401×778. Rechercher iphone puis extraire le nombre indépendamment de l'espace.

Outillage en fin de lot : client vivant mais caméra 1×1, PlayerGui 800×600/504 après plusieurs démarrages. Captures et une entrée souris n'ont pas abouti ; attentes annulées après vérification indépendante, aucun succès supposé. Une ancienne capture Options a été inspectée avant les derniers onglets, aucune capture finale acceptée. RenderStepped:Wait supprimé du sampler pour ne pas attendre un rendu absent. Set3dRenderingEnabled refusé faute de capacité RobloxScript, sans changement réussi. Les arrêts de Play ont servi à persister les corrections réelles ; ne pas relancer sur le seul timeout.

**Reprise prioritaire :** vérifier que l'onglet client est visible et ViewportSize >100×100, puis tester les sept pages, les achats UI, fusion/équipement, cadeau, options, dernière ligne et rotation portrait/paysage/PC selon docs/reference/UI_MOBILE.md. Une question asynchrone sur l'onglet visible attendait toujours une réponse à la fin. Les derniers fixtures démarrent le personnage pour les boutiques ; ils ne prouvent pas le parcours Jouer distinct ci-dessus. Source finale compilée et synchronisée, vérification visuelle encore à faire.

Play arrêté, simulateur default/LandscapeLeft, aucun QA en Edit. Context7 consulté ; Codex on Crack doctor workflow-ready sans rôle configuré, travail direct. Panel toujours state_unreadable, aucune approbation revendiquée. Aucune publication/sauvegarde .rbxl confirmée, aucun essai tactile/manette physique, multijoueur ou production. L'objectif général reste actif.

Lot précédent : **fusil à pompe des quais**, niveau 16 / 11 500 pièces, cinq cartouches, recharge 2,9 s, portée 75, cadence 0,95 s. Sept plombs ×20, dispersion fixe serveur centre + couronne 4,5°. Les dégâts sont regroupés par cible avant TakeDamage et PunchHit : un chiffre et une récompense par mort, plusieurs zombies possibles par tir. Les murs solides bloquent même transparents ; décorations non solides traversées sous limite de 32 raycasts par plomb. Le client n'envoie que sa direction. Armes précédentes à une seule direction préservées. Voir docs/reference/ARMES_A_FEU.md.

Nouveau ModuleScript ReplicatedStorage.FirearmBallistics. Huit sources et instances modifiées : GameplayConfig, WeaponVisuals, WeaponMotion, FirearmsServer, FirearmsClient, FistsClient, CharacterCombat et GameHub ; versions précédentes dans ServerStorage.BeforeShotgun. Manifeste/AGENTS : 41 scripts actifs. Pas de changement du schéma Meta ni des reçus, achats pièces disponibles dans l'UI, Robux toujours désactivé. Aucun constructeur de scène exécuté.

Modèle distinct crosse/canon long/tube/pompe rainurée/cartouches latérales, soutien gauche sous le garde-main, recul et recharge propres. Pompe mobile première personne et geste de pompe corporel ; modèle porté statique. Cinq gestes d'insertion, puis mécanisme final, mais remplissage atomique de cinq cartouches à 2,9 s. Pas de recharge partielle. Poses/cycle atténués avec ReducedMotion ; débattement fonctionnel précédent du barillet de revolver conservé. ShotFX envoie une liste de destinations et l'ID au moment du tir ; sept traceurs mais un seul flash et une seule détonation, puis clic de pompe. Asset métal existant réutilisé, pas de nouvel enregistrement sonore.

Preuves dans studio/qa/shotgun-result.json : **33 régressions anciennes armes + 30 contrôles fusil + cinq contrôles vraie mort**, tous passés. Tirs par vrai remote client : 140 dégâts/une cartouche, deux cibles, un seul changement de santé par cible, obstacles, portée, zone, anti-spam/recharge/annulation. Un vrai Civilian tué par un tir : +8 pièces/+20 XP exactement une fois. Première assertion du harnais réelle mort supposait à tort un chargeur neuf après les tests précédents ; remplacée par la comparaison à l'état précédant le tir. Les profils temporaires ont été restaurés, puis Play arrêté.

Achat réellement cliqué sur PC 1447×801 : 20 000 → 8 500, fusil équipé sans remplissage gratuit du chargeur déjà utilisé dans la session. Animation rendue finale : pompe ~0,2198 stud, retour <0,00001 ; recharge six clics et cinq cartouches ; main droite ~0,657 rad normal contre ~0,164 réduit. Instances sonores et option muette observées, aucune audition revendiquée. La capture PC précède le dernier placement de main gauche, les captures mobiles utilisent ce placement final. Poses entre plusieurs joueurs non vérifiées.

iPhone 7 simulé **666×374 paysage / 374×666 portrait** (libellé corrigé au lot suivant), captures inspectées avec deux boosts. En paysage <700 px, l'ancien compteur à droite chevauchait FRANCHIR/SPRINT ; il est maintenant à gauche sous statistiques/boosts (14,249,170,42). Portrait (180,249,170,42), commandes contrôlées sous Y373. Le grand cadre transparent du joystick dynamique couvre partiellement cette zone, mais le compteur est non interactif et les commandes visibles sont séparées. TIR activé à la souris avec les contrôles d'origine, chargeur 5→4 ; seul le pointeur avait une libération temporaire de QA, retirée ensuite. Pas un test tactile physique. Le reflow portrait des pages boutique reste à faire.

Console finale Play : un avertissement interne Roblox Assistant RemoteServiceGate, aucune erreur de script de jeu observée. Play arrêté, simulateur default/LandscapeLeft. Audit final séparé confirme 41/41 synchronisés et compilants. Aucun multijoueur, manette/tactile physique, reconnexion/persistance de production, audition, benchmark ou équilibrage long. Aucune publication ni sauvegarde .rbxl confirmée. L'utilisateur confirme que la carte s'affiche normalement chez lui : ne pas modifier l'éclairage pour les anciennes captures noires de l'outil. L'objectif général d'enrichissement reste en cours.

Lot précédent : **dossiers d'expédition permanents**, trois objectifs par zone : 6 éliminations, 3 espèces éliminées, 18 éliminations. Les compteurs se cumulent ; chaque étape se récupère une seule fois, dans l'ordre, via Missions & dossiers. Douze récompenses fixes, total 22 815 pièces / 10 125 XP, sans multiplicateur de pet/boost. Aucun rétrocalcul des anciennes éliminations. Voir docs/reference/EXPEDITIONS.md pour les montants par zone et la sauvegarde.

Nouveau ModuleScript ReplicatedStorage.Expeditions (studio/Expeditions.luau), EconomyService et GameHub modifiés ; deux scripts précédents dans ServerStorage.BeforeExpeditions. Nouveau champ Meta.Expeditions[zoneId]={Kills,Seen,Claimed}, compteurs bornés 18/3. Les autres champs et reçus sont conservés, les données de zones futures inconnues ne sont pas supprimées. Sauvegarde via le Meta JSON, les clés et le bail existants de ProgressionService, sans autre DataStore. Les réclamations ClaimExpedition ont un identifiant canonique City:1, exigent le niveau et l'étape suivante ; reçu avancé avant paiement, rétabli si AddRewards refuse. L'économie et les achats depuis n'importe où restent serveur. Robux désactivé.

Présentation : page Missions renommée Missions & dossiers, suivi OBJECTIFS de la zone actuelle sur PC >=1000×600. Le panneau est masqué sur petit écran/mobile, la page reste accessible. Missions portrait tactile utilise une fenêtre haute, lignes/textes plus grands et commandes ~48 px ; onglets et fermeture adaptés, disposition large rétablie après rotation. Les autres pages gardent leur disposition antérieure. Le premier essai portrait avait des boutons ~32,5 px ; le reflow donne ~48,2 px et une fenêtre ~377×754 sur 401×778.

Preuves : studio/qa/expeditions-result.json, 38 contrôles dossiers et 27 régressions économiques (ce dernier nombre dépend des fragments aléatoires inspectés). Douze paiements exacts/refus des doublons, identifiants falsifiés, progression par espèce/niveau, refus de faux kills client, changement de jour sans remise à zéro des dossiers. Un décès attribué synthétiquement au vrai directeur valide le lien ; les autres kills de cette suite sont des callbacks serveur synthétiques. Round trip JSON validé, pas une reconnexion ni une écriture DataStore de production.

Récupérations par clic PC et portrait simulé : 1000 → 1120 pièces, +60 XP et étape 2 affichée immédiatement. Captures PC et iPhone 17 Pro paysage 750×381 / portrait 401×778 inspectées ; descriptions mesurées sans débordement. Suivi prêt lisible à 1200×720, aucun chevauchement avec ONDE ; suivi masqué à 1200×539. Retour portrait → paysage vérifié. Les tentatives de ciblage de l'outil sont dépendantes du support : **PC, centre absolu du bouton** ; **téléphone testé, centre absolu moins origine du ScreenGui**. La correction mobile appliquée au PC n'a pas cliqué la récompense. Vérifier le résultat serveur et ne pas généraliser une formule. Tous les tests sont SessionStudio ; pas de tactile/manette physique, multijoueur, audition ou équilibrage long.

Context7 consulté sur autorité serveur et sauvegardes à bail. Aucun constructeur de scène exécuté. Fixtures retirées par arrêt de Play, console finale vide, audit 40/40 synchronisés et compilants. L'objectif d'enrichissement continu reste actif.

Lot précédent : **onde de choc**, déblocage niveau 5, Q / L1 / bouton ONDE. Coût 30 sur le vrai état d'endurance SprintServer, délai 14 s conservé après réapparition pendant la session, rayon 14, dégâts 20, interruption 0,7 s, repousse adaptée à la masse/échelle, 12 cibles au plus. Refus en dehors d'une zone autorisée, dans les menus, en l'air, accroupi, pendant glissade/franchissement/dash/recharge, sans endurance ou avant le niveau. Les murs solides même transparents bloquent l'effet. Aucun coût en pièces ni nouveau champ DataStore. Voir docs/reference/CAPACITES.md.

Nouveaux scripts : ServerScriptService.PulseAbility (ModuleScript, studio/PulseAbility.luau), StarterPlayerScripts.PulseClient (studio/Pulse.client.luau). Modifiés : GameplayConfig, SprintServer, ZombieDirector, WeaponMotion, FistsClient, CharacterCombat, ZoneGuide. Sept versions précédentes dans ServerStorage.BeforePulseAbility. SprintServer crée UseAbility/PulseFX au lancement ; le client envoie seulement Pulse, pas de montant ou cible. Le directeur interrompt la marche et garde les dégâts différés sous contrôle StunnedUntil. Poses compatibles avec le système Motor6D/AnimationConstraint existant, effet cyan/or et BOUM ; réduction des poses à 25 %, six traits au lieu de douze en mouvements réduits. Son existant réutilisé et option SFX respectée.

Preuves : studio/qa/pulse-result.json, 29 contrôles réussis. Les refus utilisent un état serveur temporaire ; les activations passent réellement par UseAbility:FireServer du pont client vers SprintServer. Coût exact, cible déplacée ~2,57 studs, dégâts de zone/occlusion/exclusions, récompenses d'une vraie mort de zombie, arrêt/reprise d'un vrai Runner, délai et réapparition réelle, maximum douze cibles, 12/6 traits, son activé/muet. Pose rendue déplacée ~0,377 / 0,094 stud normal/réduit. Les premières erreurs venaient du harnais (synchronisation du menu, compteur FX accumulé, santé du Runner réutilisée) ; le harnais final observe le tick IA et passe. La préparation d'attaque ennemie interrompue n'a pas été mise en scène séparément.

Entrées/UI : vraie touche Q acceptée. Bouton dans l'écran et sans chevauchement avec les panneaux/commandes contrôlés sur iPhone 17 Pro simulé 750×381 et 401×778 ; captures inspectées. Clic souris portrait confirmé avec la liaison FistsPunch d'origine, après libération temporaire du pointeur par fixture. **Coordonnées d'entrée = centre absolu du bouton − AbsolutePosition du ScreenGui ancêtre** (origine Y=-58 ici) ; instance_path n'atteignait pas le bouton. Down/attente/Up utilisés et Activated/PulseAt vérifiés. Ne pas corriger le jeu pour compenser les coordonnées de l'outil.

Jouer portrait également vérifié depuis un menu préparé : compteur Activated 1, HasStarted false → true, InGameMenu false, accueil masqué. L'état observé au début d'une autre session était déjà démarré : aucune preuve de démarrage initial naturel tirée de cette observation. Le diagnostic explique les anciennes tentatives automatiques sans effet ; tactile/manette physiques toujours non couverts. Toutes les fixtures/counters/pointeurs temporaires ont disparu à l'arrêt de Play ; console finale vide.

Outillage de ce lot : Context7 consulté sur ApplyImpulse/AssemblyMass et propriété réseau ; Codex on Crack doctor toujours workflow-ready sans rôle délégué configuré, travail direct. Le panel renvoie encore state_unreadable, aucune approbation revendiquée. Aucun constructeur de carte exécuté dans ce lot.

Lot précédent : **Port des cendres, niveau 20**, installé en Edit à X=1860. Quatrième zone, six apparitions et trois espèces : Matelot noyé (650 PV, 320 pièces/500 XP), Écumeur des cendres (800, 420/650), Titan de l'ancre (1200, 650/1000). Nouveaux templates Drowned, Raider, AnchorTitan : six maillages humains existants par rig, avec accessoires/silhouettes propres. Familiers Crabi (crabe), Requinou (requin), Krakenou (tentacules), fusion de trois fragments et bonus intégrés au catalogue. Douze espèces au total. Voir docs/reference/ZONES.md pour les valeurs et dépendances exactes.

Scène ajoutée : workspace.ProgressionZones.Harbor, 180 BaseParts (206 descendants au premier relevé), quais/avenue/conteneurs/grues/épaves/lampes et trois caisses franchissables. Nouveau portail refuge Travel_Harbor à (64,4.5,208), prolongement HarborExpeditionPad, retour Return_Harbor à (1882,4.5,20). Aucun objet de carte existant remplacé. Eau décorative sur fond solide, sans noyade. Teinte froide/vent local renforcé, aucun nouvel asset sonore.

Sources modifiées : WorldConfig, GameplayConfig, ZombieFactory, GameHub, ZoneGuide, PresentationClient, MovementConfig et AdvancedMovement ; huit versions précédentes dans ServerStorage.BeforeHarbor. BuildHarborExpansion.luau est ponctuel Edit, pas un script actif. Il nécessite les anciens templates humains améliorés, utilise des clones de modules pour éviter un cache require périmé, puis les supprime. Réexécution vérifiée : « Harbor already built; no mutation ». Une scène partielle est volontairement refusée pour inspection. Les autres constructeurs ne doivent pas être relancés pour cet ajout.

Preuves dans studio/qa/harbor-result.json : 38 contrôles de zone/services, 28 régressions économie (nombre dépendant des fragments aléatoires), 15 contrôles de combat, 12 régressions déplacement et huit obstacles terrain. Le harnais de services attribue des dégâts létaux synthétiques aux vrais zombies pour contrôler récompenses/réapparition. Le harnais HarborCombat utilise séparément de vrais Shoot:FireServer client : dix tirs de revolver et recharge automatique tuent le matelot ; +320 pièces/+500 XP, deux balles restantes. Ne pas confondre ces deux preuves.

Portails réellement activés avec E depuis des approches préparées : niveau 19 refusé, 20 admis, arrivée puis retour refuge. Flèche PORT NIV.20 visible en 750×381 et 401×778 simulés, dans les limites de l'écran et masquée à l'arrivée. Les trois familiers équipés ont des signatures de pièces distinctes, puis leurs clones ont été inspectés dans un panneau QA temporaire. Les trois zombies ont été inspectés de près dans la scène native Play avec racines temporairement ancrées et bras du joueur masqués ; le panneau de clones zombies vide n'est pas une preuve visuelle. Toutes ces fixtures ont disparu à l'arrêt de Play. Console finale vide. Aucun essai multijoueur, tactile/manette physique, DataStore production, audition sonore ou équilibrage de longue durée.

Déplacements : un essai propre sans marche maintenue a montré un arrêt sur les sacs de sable de la ville. Assistance allongée à 0,38 s ; dégagement/réception contrôlés sur VaultForwardSpeed × VaultDuration + 0,5. Coût inchangé. Nouvelle passe : huit obstacles déclenchés/franchis/atterris/coût payé, dont trois au port ; 12 régressions Movement réussies. Parcours clavier port ~72,84 studs, pointe ~65,08, sprint/glissade/dash observés, aucun dash pendant glissade. Les premières observations perturbées par le séquencement des entrées ne sont pas comptées comme réussites ; recréer le pont TerrainMovement après chaque harnais car il est détruit à la fin. Les samplers QA ont été adaptés aux nouvelles zones/espèces sans les installer en Edit.

Lot précédent : revolver du pisteur installé (niveau 12, 6 800 pièces, 72 dégâts, portée 180, cadence 0,72 s, six balles, recharge 2,6 s). Modèle bois/métal distinct avec six amorces et chien, aperçu armurerie, recul/recharge propres et trois étapes mécaniques utilisant l'asset métal existant. Barillet animé en première personne ; modèle porté statique avec pose corporelle dédiée. Services serveur existants pour achats/tirs. Aucun changement du schéma de sauvegarde ou des reçus ; Robux désactivé.

Fichiers modifiés de ce lot : GameplayConfig, WeaponVisuals, WeaponMotion, FistsClient, FirearmsClient, CharacterCombat, InterfaceV2, GameHub et ZoneGuide (fichiers exacts dans le manifeste). Neuf versions précédentes dans ServerStorage.BeforeRevolver. Aucun constructeur de scène exécuté. Poses d'attaque/recharge atténuées avec ReducedMotion. Ombres InterfaceV2 synchronisées avec l'UIScale de leur carte : correction du grand fond sombre du niveau en portrait.

Preuves : 33 contrôles Firearms réussis via le pont client (19 précédents + 14 revolver). Achat par clic PC : débit 10 000 → 3 200, revolver équipé avec six balles. RevolverPresentation.client.luau échantillonne le modèle rendu pendant deux recharges : ouverture ~0,354 stud puis retour <0,00002, trois clics mécaniques, chargeur rempli ; rotation de main 1,014 rad normale contre 0,254 en ReducedMotion. Instances sonores observées, aucune audition revendiquée. Rapport studio/qa/revolver-result.json ; docs/reference/ARMES_A_FEU.md détaille le contenu.

Mobile iPhone 17 Pro simulé : rectangles munitions/Options/niveau/statut et sept commandes contrôlés sans chevauchement avec les munitions en 750×381 et 401×778. Recharge à gauche de Tir en paysage large ; Options sous le niveau en portrait. Captures inspectées, dont le portrait final après correction des ombres ; ombre et carte mesurées à 244,8×43,52. Les derniers clics simulés sur Jouer en portrait sont restés sans effet ; démarrage via fixture serveur pour le contrôle visuel final. Ne pas revendiquer un essai tactile physique réussi ; cause d'entrée à examiner.

ZoneGuide : la découverte CAS dans refresh peut céder l'exécution ; une baisse de niveau pouvait alors vider pending avant target et provoquer pending.Id nil. Garde ajoutée juste après refresh. Test de 100 changements de niveau terminé, flèche LABO visible et console finale vide. Une requête supplémentaire de géométrie Client est restée sans réponse : attente annulée après contrôle indépendant de l'état Play, de la capture et de la console ; aucun résultat de cette requête supposé. Play ensuite arrêté normalement ; simulateur default/LandscapeLeft et 37/37 scripts synchronisés/compilants confirmés.

Outillage : Context7 consulté sur les priorités de rendu Roblox et PreSimulation. Codex on Crack doctor : workflow-ready, aucun rôle délégué configuré ; travail direct, aucun agent substitué. Le panel renvoie toujours state_unreadable / « The review record is not a private regular file. » ; aucune approbation du panel revendiquée.

Lot précédent : ZoneGuide.client.luau ajouté à StarterPlayerScripts.ZoneGuide. Une hausse de niveau franchissant un seuil affiche une flèche cartoon vers le portail de la nouvelle zone ; depuis une autre zone, elle dirige d'abord vers le retour au refuge. Aucun rappel pour les niveaux déjà possédés à la connexion. Masquée dans les menus et à la mort, supprimée à l'arrivée. Pulsation désactivée avec ReducedMotion. Les accès restent validés serveur.

AdvancedMovement et MovementClient corrigent une impulsion de franchissement perdue pour le propriétaire client : confirmation serveur VaultAccepted sur le remote existant, impulsion locale uniquement si le personnage est encore au sol. Backup ServerStorage.BeforeOwnedVaultLaunch. Quatre modèles permanents ajoutés en Edit dans workspace.TraversalCover (deux Usine, deux Labo), sans remplacer la scène. studio/BuildTraversalCover.luau reste un constructeur ponctuel, jamais un script actif. Aucun MaterialVariant présent au contrôle : ne pas annoncer de matériaux PBR ajoutés par ce lot.

Preuves : cinq franchissements physiques via pont client réussis, contre deux obstacles bloquants avant correction ; 12 régressions Movement réussies ; parcours clavier sprint/glissade/dash réussis sur une avenue de chacune des trois zones. Rapports terrain-vault-before-fix.json, terrain-vault-result.json, movement-owner-fix-regression.json et terrain-locomotion-result.json dans studio/qa. Ne couvre pas tous les reliefs ni une forte latence.

Guide : niveau 4 sans flèche, 5 vers Usine, arrivée Usine masquée ; niveau 12 depuis Usine vers le retour refuge puis le portail Labo, arrivée Labo masquée. Portails activés avec E depuis des approches préparées pour le test. Flèche écran inspectée sur PC et iPhone 17 Pro simulé (750×381, 401×778), rectangles dans l'écran ; ReducedMotion maintient UIScale=1. Le Billboard a un Adornee valide et Enabled=true ; son rendu visuel n'est pas établi par ces captures. Console finale : une assertion de fixture erronée (SessionStudio au lieu de PersistenceMode) corrigée avant toute mutation ; aucune erreur de script de jeu dans la sortie lue. Résultats zone-guide-result.json. Tactile physique, manette et multijoueur non vérifiés.

Le bouton SOURIS [M] d'InterfaceV2 est maintenant terminé, installé et testé. M libère le pointeur ; M/REPRENDRE revient au combat. Un GuiButton modal et un réglage après la caméra (priorité Camera+30) maintiennent réellement MouseBehavior.Default. Les menus/réapparitions réinitialisent le mode ; les changements transitoires de capacité d'entrée sont vérifiés après 0,2 s. Bouton masqué sur tactile. FistsClient empêche les attaques pendant la navigation et invalide les frappes différées lors d'une interruption de menu, focus ou souris. Le mode ne modifie ni monnaie ni validations serveur, et ne met pas le monde en pause.

GameHub et ProgressionClient incluent désormais les notifications adaptées au format : en paysage tactile, largeur 300 sur le téléphone testé et espace réservé au panneau de statut ; en portrait, placement sous vie, boosts et munitions visibles. HubToast est empilé sous ProgressToast avec la marge d'interface prise en compte.

Séries d'éliminations installées : fenêtre de 8 secondes prolongée par élimination validée, record de session, titres Double/Triple K.O. et paliers, barre de délai dans le bandeau de gains. Aucun multiplicateur économique supplémentaire. Autorité serveur, aucun nouveau remote de commande client. Mort, réapparition et expiration remettent la série à zéro ; le record survit à la mort pendant la session.

### Preuves récentes et suites

KillChains.server.luau : 11 contrôles réussis sur callbacks serveur synthétiques en SessionStudio (kill-chains-result.json). Ils ne prouvent pas une séquence de combat réelle ni le multijoueur.

Disposition : capture PC avec série et fragment simultanés, écart de 8 px ; iPhone 17 Pro simulé configuré avant Play, paysage 750 × 381 et portrait 401 × 778. Captures inspectées et rectangles mesurés : aucun chevauchement entre les deux notifications ni avec vie, boosts et munitions contrôlés ; écart de 8 px en paysage, 7,8 px en portrait après mise à l'échelle. Les comptes à rebours XP/pièces sont visibles dans les deux orientations. Console vide au contrôle. Résultats : studio/qa/notification-layout-result.json. Le tactile physique, les autres ratios et la réplication multijoueur restent à vérifier.

L'ancien échec du contrôle d'approbation pour quota est résolu pour ces installations : elles ont réussi par le circuit normal après vérification de l'utilisation disponible, sans contournement. Backups BeforeKillChains, BeforeNotificationStacking et BeforeResponsiveNotifications dans ServerStorage.

Navigation souris : 11 contrôles dans studio/qa/mouse-navigation-result.json, dont 30 images de pointeur libre, activation réelle des Options, refus de M dans le menu, retour au verrouillage, absence de frappe/consommation de balle pendant la navigation, annulation d'une préparation de mêlée par sonde chronométrée, réapparition et masquage sur iPhone simulé. Les boutons Options/Souris/Boutiques ont été séparés (marges mesurées 7 et 10 px). Capture PC inspectée ; console vide. Backups des scripts précédents dans ServerStorage.BeforeMouseNavigation. Le tactile physique et le multijoueur ne sont pas couverts.

Prochaine étape utile : finir docs/reference/UI_MOBILE.md sur un vrai viewport client, puis événements de zone, équilibrage du fusil à pompe et détails de scène. Les objectifs d'expédition et l'onde sont désormais installés. Continuer aussi le reflow portrait des autres pages, vérifier notifications simultanées avec ONDE, démarrage initial sans fixture et animations entre joueurs. Le tactile/manette physique et les sauvegardes de production ne sont pas couverts par les preuves Studio. L'objectif général d'enrichissement continu reste en cours.

## Carte du code

ZombieNavigation (ServerScriptService) : file de calculs, révisions, suivi horizontal, détection d’immobilité et arrêt ; contrôleur par zombie dans ZombieDirector.

ZombieMelee (ServerScriptService) : contrôleurs d’attaque ennemie, délais/cône/occlusion/annulation et avertissement ; créé/détruit par ZombieDirector.

FirearmBallistics (ReplicatedStorage) : directions de tir partagées, sept plombs fixes pour le fusil à pompe ; autorité des dégâts dans FirearmsServer.

Le manifeste `studio/runtime-manifest.json` liste les 43 scripts actifs, leur classe, leur fichier source local et leur chemin DataModel.

| Fonction | Fichiers principaux dans studio/ |

| --- | --- |

| Catalogue, prix, récompenses, pets | `GameplayConfig.luau` |

| Achats, équipement, fragments, cadeaux, contrats | `EconomyService.luau`, `QuickContracts.luau` |

| Dossiers permanents par zone | `Expeditions.luau`, `EconomyService.luau`, `GameHub.client.luau` |

| Profil, pièces, XP, niveaux, sauvegarde | `ProgressionService.luau`, `PlayerCurrency.server.luau` |

| Menus, boutiques, accueil, options | `GameHub.client.luau` |

| HUD, habillage et cible | `SurvivalHUD.client.luau`, `InterfaceV2.client.luau`, `Progression.client.luau`, `TargetHUD.client.luau` |

| Images et logo pièce | `CartoonArt.luau`, `CoinIcon.luau` |

| Combat de mêlée et vue subjective | `FistsServer.server.luau`, `FistsClient.client.luau`, `FistsConfig.luau` |

| Modèles et profils d'animation | `WeaponVisuals.luau`, `WeaponMotion.luau` |

| Poses corporelles | `CharacterCombat.client.luau` |

| Tir, munitions, recharge | `Firearms.server.luau`, `Firearms.client.luau` |

| Sprint, endurance, dash | `Sprint.server.luau`, `Sprint.client.luau`, `SprintState.luau`, `SprintConfig.luau` |

| Accroupissement, glissade, franchissement | `AdvancedMovement.luau`, `Movement.client.luau`, `MovementConfig.luau` |

| Onde de choc, bouton, poses, effets | `PulseAbility.luau`, `Pulse.client.luau`, `GameplayConfig.luau`, `WeaponMotion.luau` |

| Zones, espèces, apparitions | `WorldConfig.luau`, `ZoneService.luau`, `ZombieFactory.luau`, `ZombieDirector.server.luau` |

| Flèche de nouvelle zone | `ZoneGuide.client.luau` |

| Ambiance, sons et effets | `PresentationConfig.luau`, `Presentation.client.luau`, `NPCPresentation.luau` |

`GameSystems` initialise `EconomyService` ; `PlayerCurrency` initialise `ProgressionService`. Toujours vérifier le manifeste avant modification.

## Fonctionnalités installées

- **Refuge et zones** : ville (niveau 1), usine (niveau 5), laboratoire (niveau 12), port des cendres (niveau 20). Trois espèces par zone avec modèles et butins distincts. Point de retour refuge à (0, 5, 220). Détails dans docs/reference/ZONES.md.

- **Arsenal mêlée & armes à feu** :

  - Mêlée : poings, tuyau, batte, hache, katana, lame Nova future premium. Modèles 3D détaillés et profils de frappe distincts.

  - Armes à feu : Pistolet du refuge (1 400 pièces, niv. 3, 24 dégâts, chargeur 12, recharge 1,6 s) et Mitraillette SMG (4 200 pièces, niv. 7, 14 dégâts, cadence 0,11 s, chargeur 24, recharge 2,1 s).

  - Revolver du pisteur (6 800 pièces, niv. 12, 72 dégâts, cadence 0,72 s, six balles, recharge 2,6 s), barillet animé à la première personne.

  - Validation serveur anti-triche : raycast physique filtrant les obstacles solides tout en traversant les déclencheurs transparents non-collisionnables, anti-spam cadence (0,9x cooldown), contrôle des munitions et réattribution `LastAttacker`.

  - Rejet absolu des attaques au poing/mêlée pendant qu'une arme à feu est équipée.

  - Annulation du rechargement et conservation des munitions lors du changement d'arme.

  - Audio différencié : son grave et percutant pour le pistolet, détonation vive et rapide avec pitch aléatoire pour la SMG, séquences mécaniques de recharge en 2 et 3 étapes.

  - Poses première personne ergonomiques : arme recentrée pour éviter l'occultation par les boutons tactiles mobiles, main gauche en soutien tactique (pistolet) ou sous le garde-main (mitraillette), recul et FOV différenciés.

- **Déplacements avancés** : sprint, dash, accélération, accroupissement (C / R1), glissade en course, franchissement d'obstacles bas (V / Y). Endurance partagée contrôlée serveur. Poses procédurales CharacterCombat (Waist, Hips, Knees, Shoulders) compatibles AnimationConstraint et Motor6D.

- **Économie & Progression** :

  - Achats en pièces (armes, vitalité, agilité) directement depuis l'interface ou les stands physiques.

  - Butin : fragments de zombies (chance 1/3) fusionnables en familiers par lots de 3. Familiers avec multiplicateurs XP/pièces/vitesse.

  - Contrats express cycliques : 3 kills, 2 espèces distinctes, 7 kills, sans temps mort. Cadeaux temporels et missions quotidiennes.

  - Robux désactivé : `MonetizationEnabled = false`, identifiants produits à 0.

## Données et sécurité

- `ProgressionService` utilise le DataStore `WeaponEvolution_Progress_v1`, clés `Player_<UserId>`, bail de session 180 s, autosave 60 s. Mode Studio confiné à `SessionStudio` sans écriture distante.

- Champs Meta obligatoires : `HealthLevel`, `SpeedLevel`, `Weapons`, `EquippedWeapon`, `Fragments`, `Pets`, `EquippedPet`, `XPBoostUntil`, `CoinBoostUntil`, `Daily`, `Receipts`, `QuickContract`.

- Règle absolue : aucune attribution de monnaie côté client. Tous les achats, dégâts, niveaux et réclamations restent sous autorité serveur.

## Preuves et limites

### Affichage des boosts temporaires

GameHub affiche ActiveBoosts près du panneau de statut et les durées XP/pièces dans le résumé des menus. Le compte à rebours utilise les échéances serveur déjà transmises et GetServerTimeNow ; il ne modifie ni attribution ni durée des boosts. Rafraîchissement à 4 Hz, sans reconstruction du catalogue. Bandeau caché sans boost, à expiration ou pendant les menus. Placement au-dessus du statut sur PC, dessous sur tactile.

Test Play : deux boosts temporaires ont affiché XP x2 00:06 / PIECES x2 00:06, puis 00:04, puis bandeau vide et masqué après expiration. Taille PC mesurée 296 × 24 ; console vide. Le placement tactile reste à contrôler visuellement. Backup BeforeBoostTimers. Boosts de test limités à SessionStudio ; Play arrêté après le contrôle.

### Obstacles des tirs

FirearmsServer bloquait uniquement les surfaces solides de transparence <0,9. Correction : toute surface CanCollide bloque, quelle que soit son opacité ; les volumes sans collision restent traversables et les zombies touchables. Recherche limitée à 32 raycasts successifs par tir ; si cette limite est atteinte avant une cible, aucun dégât n'est accordé à travers les éléments restants. Backup BeforeSolidShotBarriers.

Harnais Firearms étendu et exécuté via son pont client : 19 contrôles réussis, dont mur opaque, mur transparent solide et volume transparent sans collision. Résultat dans studio/qa/solid-barriers-result.json ; console vide. Le plafond de 32 passages est vérifié dans le code mais pas encore soumis à un test de charge. Cette preuve est postérieure à la suite de 17 contrôles ci-dessous.

### Régression vérifiée après correction du harnais

Le fichier Firearms.server.luau appelait FireServer depuis le serveur : ses anciennes affirmations de réussite ne suffisaient pas à prouver ce harnais reproductible. Il a été corrigé avec FirearmsBridge.client.luau, un pont client strictement temporaire en Studio Play. La rafale de cinq tirs part désormais en une seule commande client et le délai de préparation respecte le cooldown.

Nouvelle exécution séquentielle : armes 17 contrôles, économie 26, déplacements 12, contrats 7, tous réussis. Résultats réellement lus dans les StringValue serveur et enregistrés dans studio/qa/regression-2026-10-22.json. La console était vide au contrôle. La procédure est dans studio/qa/README.md. Cette nouvelle preuve remplace l'ancien total « 18 contrôles Firearms » ci-dessous ; elle ne valide pas les scénarios absents, notamment le test de volume transparent et la recharge complète du pistolet dans ce harnais précis. Les anciennes vérifications manuelles restent des preuves séparées. Arrêt de Play demandé après la suite pour retirer le pont et les fixtures.

### Correction des axes des épaules — reprise du 22 octobre

Diagnostic suivant : le fond noir des captures se reproduit après un clic normal sur JOUER. L'utilisateur a confirmé explicitement que la carte s'affiche normalement dans son Studio. Traiter donc ce résultat comme une limitation de capture/observation, pas comme une panne visuelle du jeu démontrée. Ne pas modifier l'éclairage ou la carte pour compenser.

Contrôles complémentaires : le moteur rapporte 141 005 triangles / 59 appels dans la vue de démarrage ; aucun grand GuiObject visible ne recouvre le viewport après démarrage ; NearPlaneZ=-0,1 et raycast central cohérent avec le portail devant le spawn. Désactivation temporaire des PostEffect sans effet sur la capture. Set3dRenderingEnabled inaccessible (capacité RobloxScript) : aucun contournement effectué. Capture demandée après Stop Play restée en attente, puis annulée explicitement ; aucun résultat visuel n'en est déduit. Stop Play a répondu Game Stopped mais une interrogation ultérieure indiquait Play : revérifier l'état courant plutôt que supposer Edit. Aucun changement permanent du rendu pendant ce diagnostic.

Instance redécouverte : Évolution des armes, placeId 78882167241715, Studio ID 45bb0222-99c2-4b04-8be7-6667f480d5e2 (à redécouvrir ensuite). La correction locale de CharacterCombat n'était pas installée : Studio conservait les rotations négatives des épaules. Comparaison effectuée ; seules les deux formules d'axes différaient. Correction installée après backup BeforeGunAxisFix.

Contrôle Play sur l'avatar AnimationConstraint : direction de la SMG vers l'avant (produit scalaire avec l'avant du personnage 0,900), composante verticale -0,044. Une recharge réelle modifie la pose de l'épaule (~0,395 rad de différence mesurée) et finit avec 24 balles. La différence résiduelle de pose (~0,114 rad) inclut l'animation de repos, ce n'est pas une preuve de retour exact. La capture de la scène est restée noire malgré une caméra et des pièces présentes : validation visuelle finale non acquise. Les mesures seules ne prouvent ni le placement précis de la main de soutien ni tous les rigs. Aucun test multijoueur. Les fixtures et caméra de test ont été supprimées en arrêtant Play.

| Vérification effectuée | Limite |

| --- | --- |

| **Harnais Firearms (19 contrôles vérifiés)** : achats et niveaux, munitions, directions invalides, cadence, murs solides opaques/transparents, déclencheur sans collision, dégâts, attribution, refus de mêlée avec arme à feu, recharge SMG et annulation | Pont client temporaire réel ; détails dans solid-barriers-result.json. La recharge complète du pistolet et le multijoueur ne sont pas couverts par cette exécution |

| **Harnais Expansion (26 contrôles)** : achats UI à distance, niveaux, fusion fragments, multiplicateurs pets, récompenses uniques | Données temporaires effacées après test |

| **Harnais Movement (12 contrôles)** : glissade physique, franchissement, atterrissage, refus obstacles hauts, endurance insuffisante, menu | Fluidité sur topographie accidentée et contrôles physiques tactiles à tester |

| **Harnais Contracts (7 contrôles)** : paliers kills, espèces distinctes, cycle immédiat, sérialisation | Pas de test de reconnexion en prod |

| **Rendu & Audio** : traceurs ambre (pistolet) et turquoise (SMG), sons de tir et recharges multi-étapes distincts, main gauche en soutien | Assets audio basés sur les transients natifs Roblox accordés en fréquence |

| **Ergonomie mobile** : HUD munitions repositionné, pistolet/SMG relevés pour dégager les boutons d'action | Contrôle physique tactile sur différents ratios d'écran à poursuivre |

## Backups dans ServerStorage

- `BeforeFirearmsPolish` (22 octobre 2026) : sauvegarde préalable de `FistsClient`, `FirearmsClient` et `FirearmsServer`.

- Backups antérieurs : `BeforeGunStances`, `BeforeSMG`, `BeforeTouchLayout`, `BeforeGiftRefresh`, `BeforeReloadPresentation`, `BeforeQuickContracts`, `BeforeFirearms`, `BeforeAdvancedMovement`, `BeforeCharacterCombat`, `BeforeCartoonRefresh`, `BeforeGameplayExpansion`.

## Guide pour la prochaine IA reprenant le relais

1. **Vérification de session** :

   - Lancer `list_roblox_studios` pour obtenir l'ID actuel.

   - Vérifier `get_studio_state` (doit être `Edit`).

   - Ne jamais modifier les scripts en mode `Play`. Les modifications pérennes se font en `Edit`.

2. **Synchronisation DataModel / Disque** :

   - Les 36 scripts sont documentés dans `studio/runtime-manifest.json` et audités dans `studio/qa/handoff-audit.json`.

   - Avant de modifier un script Studio, toujours comparer avec le fichier local correspondant.

   - Ne jamais installer les constructeurs `Build*`, `Install*`, ni les scripts `qa/` comme scripts permanents.

3. **Tester un script serveur en Play** :

   - En raison du cache distinct de `require()` dans `execute_luau`, pour tester les services de jeu, créer un `Script` temporaire dans `ServerScriptService`, lire son résultat (ex. via un `StringValue` ou un attribut), puis détruire le script temporaire et arrêter Play.

   - Les tests de remotes côté client s'exécutent en `datamodel_type = "Client"`.

4. **Prochaines étapes recommandées** :

   - *Passe visuelle et tactile tous formats* : valider le rendu du HUD et des menus sur divers formats mobiles simulés (tablette, petits écrans portrait/paysage).

   - *Chaîne de mouvement en situation réelle* : tester la fluidité sprint → glissade → franchissement → dash sur le terrain varié des zones extérieures (ville, usine, labo).

   - *Profils multijoueur* : observer la réplication visuelle des poses de tir et de rechargement entre plusieurs personnages.

   - *Équilibrage & progression* : ajuster les paliers de dégâts et de récompenses pour les vagues de zombies avancées.



Audit final admin : 46/46 scripts compilent, aucun script QA/non répertorié dans les racines runtime Edit. 45/46 sources identiques après normalisation ; seul PlayerCurrency diffère par son commentaire local historique (appel Init identique), laissé intact. Les trois sources du lot sont synchronisées. Edit confirmé, default/LandscapeLeft.
