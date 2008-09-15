#!/bin/sh

cd $CMSSW_BASE/src/Configuration/GenProduction/python/

cat Herwigpp_mkrun.table | while read MINKT XS EVTS; do
	sed -e "s/__MINKT__/$MINKT/;s/__XS__/$XS/" Herwigpp_mkrun.template > Herwigpp_QCD_Pt_$MINKT.py;
done

CONDITION="FrontierConditions_GlobalTag,IDEAL_V9::All"

scramv1 b --reset

cat Herwigpp_mkrun.table | while read MINKT XS EVTS; do
	cmsDriver.py Configuration/GenProduction/python/Herwigpp_QCD_Pt_$MINKT.py \
		-s GEN \
		--eventcontent RAWSIM --datatier GEN \
		--conditions $CONDITION -n $EVTS --no_exec \
		--customise Configuration/GenProduction/Herwigpp_custom.py
	sed -i -e "s/_py_/_/" Herwigpp_QCD_Pt_${MINKT}_py_GEN_IDEAL.py

	cmsDriver.py Configuration/GenProduction/python/Herwigpp_QCD_Pt_$MINKT.py \
		-s GEN,SIM,DIGI,L1,DIGI2RAW,HLT \
		--eventcontent RAWSIM --datatier GEN-SIM-RAW \
		--conditions $CONDITION -n $EVTS --no_exec \
		--customise Configuration/GenProduction/Herwigpp_custom.py
	sed -i -e "s/_py_/_/" Herwigpp_QCD_Pt_${MINKT}_py_GEN_SIM_DIGI_L1_DIGI2RAW_HLT_IDEAL.py
done
