require 'enumerator'

module Enumerable
  #  sum of an array of numbers
  def sum
    return self.inject(0){|acc,i|acc +i}
  end
  #  average of an array of numbers
  def average
    return self.sum/self.length.to_f
  end
  #  variance of an array of numbers
  def sample_variance
    avg=self.average
    sum=self.inject(0){|acc,i|acc +(i-avg)**2}
    return(1/self.length.to_f*sum)
  end
  #  standard deviation of an array of numbers
  def standard_deviation
    return Math.sqrt(self.sample_variance)
  end
end

  def quantile(values, n)
    values.sort!
    breaks = []
    Array.new(n).enum_with_index.map { |x, i| 
      breaks << values[(i * (values.length) / n).ceil]
    }
    breaks[n] = values.last
    breaks
  end

  def equal_interval(values, n)
    values.sort!
    range = values.last.to_i - values.first.to_i
    b = []
    Array.new(n).enum_with_index.map { |x, i|
      b << values.first.to_i + i * range / n
    }
    b << values.last.to_i
  end


. Assuming we know min, max, mean and stdev.
1. Let user select number of standard deviations such as 1, 1/2, 1/3 etc
Lets call this selection as "k" where k is 1, 1/2, 1/3, 1/4.

2. Subtract "m*k*stdev" from "mean". where m = 1, 2, 3 to find out when
  mean - m*k*stdev <= 0

2A. Knowing values of "m" and "k", now We have to determine first class
break that
   is greater than zero.
   If m =1 then
   First class break "C1" above zero = Stdev - k*mean
   else
   First class break "C1" above zero = Stdev - (m-1)*k*mean
   So the first interval is [0, C1] and lable it as
   < m*stdev
   note square brackets mean 0 and C1 are included.

3.  Just add "stdev" to "C1" to get the second class break value "C2"
   C2 = stdev + C1
   and so forth.

4.  If max values  >> stdev >> mean
   then you may stop arbitrarily after a few classes and put generate
   the last interval that includes all of the values and lable that
   interval as
C*n


Here is what ArcGIS class intervals are for 1 stdev, 1/2 stdev, 1/3 stdev,
1/4 stdev etc...

1 Stdev
0-29  = < 0.5 stdev
30-69 = 0.5 stdev to 1.5 stdev
70 = > 1.5 stdev

1/2 Stdev
0-19
20-39
40-59
60-79
80-99

  
  def std_dev(values, n)
    min = values.min
    max = values.max
    mean = values.average
    stdev = values.standard_deviation

    puts "mean #{mean}, stdev #{stdev}"
 
    breaks = [values.min]
    n -= 1 if (n % 2 != 0)
    (0...n).each do |i|
      breaks << (mean - stdev * ((n / 2 - i) - 0.5)).round
    end
    breaks << values.max
    breaks
  end

  def max_breaks(values, n)
    # // quick and dirty way to accept either an array of features (with a "value" property) or an array of numbers
    n = [n, values.length].min
    difArray = []
    (0...(values.length - 1)).each do |i|
      dif = values[i + 1] - values[i]
      midPoint = dif / 2 + values[i]
      difArray << {:index => i, :midPoint =>  midPoint, :dif => dif}
    end
    difArray.sort! {|a,b| a[:dif]<=>b[:dif]}.reverse!
    breaks = []
    (0...(n - 1)).each do |i|
      breaks.push(difArray[i][:midPoint])
    end
    breaks.sort!
    first = values[0]
    last = values[values.length - 1]
    breaks.unshift(first)
    breaks.push(last + (last - first) / 1000)
    breaks

    #var difArray = [];
    #      for (var i=0; i< features.length-1; i++){
    #        dif = features[i + 1] - features[i];
    #        midPoint = dif / 2 + features[i];
    #        difArray.push({ 'midPoint': midPoint, 'dif': dif });
    #      }
    #      difArray.sort(function(a, b) {return a.dif - b.dif});
    #      var breaks = pv.range(n-1).map(function(i) {return difArray[i]['midPoint']});
    #      breaks.sort();
    #      breaks.unshift(range[0]);
    #      breaks[n] = range[1] + data_range / 1000;
    #      break;
  end

