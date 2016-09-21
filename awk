# awk

# bloquer les IP qui ont plus de 10 de connexions
awk ‘{a[$1]++ } END{for(i in a){if(a[i]>10)print “-I INPUT -s ” i ” -j DROP”}}’ > /home/sdc/export/iptables_block.txt
