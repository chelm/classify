require 'calcs'

data = File.open(ARGV[0], 'r').read().split(',')
data.collect! {|d| d.to_i}
#print "std dev: #{data.standard_deviation}\n"
#print "mean: #{data.average}\n"

print "Quantile Breaks with 5 classes:\n"
print "\tExpected: 1002,1020,1036,1052,1075,1096 \n"
print "\tQuantile: #{quantile(data, 5).join(',')}\n\n"

print "Quantile Breaks with 6 classes:\n"
print "\tExpected: 1002,1015,1030,1043,1059,1080,1096 \n"
print "\tQuantile: #{quantile(data, 6).join(',')}\n\n"

print "Eq. Int Breaks with 5 classes:\n"
print "\tExpected: 1002,1021,1040,1058,1077,1096 \n"
print "\tEqBreaks: #{equal_interval(data, 5).join(',')}\n\n"

print "Eq. Int Breaks with 6 classes:\n"
print "\tExpected: 1002,1018,1033,1049,1065,1080,1096\n"
print "\tEqBreaks: #{equal_interval(data, 6).join(',')}\n\n"

print "Std. Dev. Breaks with 5 classes:\n"
print "\tExpected: 1002,1005,1032,1059,1086,1096\n"
print "\tSdBreaks: #{std_dev(data, 5).sort.join(',')}\n"

print "Max Breaks with 5 classes:\n"
print "\tExpected: 1002,1017,1037,1056,1076,1096\n"
#print "\tMxBreaks: #{max_breaks([2,2,4,8,8,9,10,15,16], 5).join(',')}\n"
print "\tMxBreaks: #{max_breaks(data, 5).join(',')}\n"

#print "Max Breaks with 6 classes:\n"
#print "\tExpected: 1002,1015,1031,1045,1062,1081,1096\n"
#print "\tMxBreaks: #{max_breaks(data, 6).join(',')}\n"


#Std Dev (1 deviation) interval breaks 5 classes 1002 (min Value) 1005,1032,1059,1086,1096
#Natural Breaks (jenks) 5 classes 1002 (min value) 1017,1037,1056,1076,1096
#Natural Breaks (jenks) 6 Classes 1002 (min value 1015,1031,1045,1062,1081,1096

