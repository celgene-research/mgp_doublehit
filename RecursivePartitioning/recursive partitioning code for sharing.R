#Goal: To perform recursive partitioning on data to build trees which will be used to generate risk models based on nodes
#Author: Adam Rosenthal

ddir="//mermaid/groups/CRABStat/Projects/Arkansas/Projects/MGP/Aug2017 Analysis/Data/"
setwd(ddir)

library(RLSplit)

#Read in data
fulldata<-read.csv('analysis_full_data.csv',header=T)
colnames(fulldata)<-tolower(colnames(fulldata))

#Patients with a designation of 'Train' or 'Test' are included in the full analysis population,
#all other patients are excluded
traintest<-fulldata[fulldata$group %in% c('Train','Test'),]
maintree<-subset(traintest,select=c('patient','d_os','d_os_flag','d_pfs','d_pfs_flag','d_age','age65','d_iss',
                                    't414','t614','t814','t1114','t141620','apobec','hyperdiploid','c_loh_percent','homologous_repair_mutations',
                                    'gain_adcy2','gain_akap1','gain_blm','gain_ccnd1','gain_chodl','gain_cks1b','amp_cks1b','gain_crbn',
                                    'gain_klf14','gain_maf','gain_myc','gain_rapgef5','gain_rnf20','gain_rras2','gain_son','gain_tnfaip8',
                                    'gain_tnxb','gain_wdr72','gain_znf227','gain_znf426','loss_abcd4','loss_atm','loss_birc3','loss_brca2',
                                    'loss_cdkn1b','loss_cdkn2a','loss_cdkn2c','loss_cyld','loss_dis3','loss_dnmt3a','loss_dock5',
                                    'loss_fam46c','loss_fgfr3','loss_park2','loss_rb1','loss_rpl5','loss_traf2','loss_traf3','loss_wwox',
                                    'bi_max','bi_nfkbia','bi_tgds','bi_tp53',
                                    'ns_actg1','ns_braf','ns_egr1','ns_fgfr3','ns_hist1h1e','ns_huwe1','ns_irf4','ns_kras','ns_mafb','ns_nras',
                                    'ns_prkd2','ns_ptpn11','ns_rasa2','ns_sp140','ns_ubr5'))
head(maintree)
names <- names(maintree)

#The following tree only considers genetic factors
#Goal: to identify high-risk genetic factors important to consider for risk classification
#Grow a large (full) tree
tree.full = tree.grow(times=maintree$d_pfs, status=maintree$d_pfs_flag,
                      x=maintree[,!(names %in% c('patient','d_os','d_os_flag','d_pfs','d_pfs_flag','d_age','age65','d_iss'))],
                      perm=1000, maxcens=.8, minnode=20, seed=5)

#Plot the large tree
tree.plot(tree.full, cex=.7, nodenum=TRUE)


#Prune the tree 
tree2 = tree.prune(obj=tree.full, penalty=4, plot=T)


tree.plot(tree2, node.lab=lab.Basic,nodenum=TRUE)

#We observe a tree defined by bi-allelic TP53 and amp CKS1B
#Accordingly, we create an indicator for the presence of either of these genetic factors
#The following tree considers both genetic and clinical factors
maintreeb<-maintree
maintreeb$any_genetic_factor<-1*(maintreeb$amp_cks1b==1 | maintreeb$bi_tp53<1)
names <- names(maintreeb)

#Grow a large (full) tree
tree.full = tree.grow(times=maintreeb$d_pfs, status=maintreeb$d_pfs_flag,
                      x=maintreeb[,(names %in% c('d_iss','bi_tp53','amp_cks1b','any_genetic_factor','age65'))],
                      perm=1000, maxcens=.80, minnode=20, seed=5)

#Plot the large tree
tree.plot(tree.full, cex=.7, nodenum=TRUE)


#Prune the tree
tree2 = tree.prune(obj=tree.full, penalty=4, plot=T)


tree.plot(tree2, node.lab=lab.Basic,nodenum=TRUE)

