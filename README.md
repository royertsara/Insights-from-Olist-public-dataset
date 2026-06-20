# Insights from Olist Public Dataset

## Contexte métier

Olist est une startup brésilienne opérant dans le secteur de la retail-tech. Elle connecte les petits commerçants et les marques locales de renom aux grandes marketplaces comme Amazon ou Mercado Livre. Concrètement, elle propose un écosystème facilitant la gestion des magasins physiques, des boutiques en ligne et de la logistique, tout en offrant une meilleure visibilité aux PME via son enseigne. Ses revenus proviennent principalement des commissions perçues sur les ventes, des frais logistiques, ainsi que des abonnements à son écosystème.

Ainsi, la satisfaction client, l'optimisation de la logistique ou encore la qualité et la performance du réseau de vendeurs partenaires jouent un rôle clé dans son succès.

## Dataset utilisé

Les données utilisées sont des données commerciales réelles anonymisées publiées par Olist sur [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_order_payments_dataset.csv). Elles comptent 100 000 commandes traitées entre 2016 et 2018 au Brésil et couvrent le cycle d'achat, du paiement à la livraison. Le schéma relationnel est composé de 9 tables (commandes, clients, articles, paiements, produits, avis, vendeurs, géolocalisation et catégories de produits).

## Axes d'analyse

En prenant en considération le contexte et les données à disposition, nous orientons l'analyse autour de 3 axes :

- **Fidélisation client** : analyse des facteurs de rétention / non-rétention et du profil des clients fidèles.

- **Efficacité logistique** : mesure des performances de livraison avec une attention particulière portée aux frais de port.

- **Profilage des vendeurs** : élaboration d'indicateurs permettant d'évaluer les partenaires.

# Méthodologie

Pour mener à bien cette analyse, nous utilisons :

- **SQL (BigQuery)** : pour le nettoyage, la préparation et l'exploration des données.
- **Python** : pour approfondir l'analyse (statistiques et corrélations).
- **Power BI** : pour concevoir un tableau de bord synthétisant nos principaux résultats.

## Structure du repo

## Résultats
- **Insights**
- **Dashboard**
- **Recommendations**
