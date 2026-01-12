require 'csv'

def ave(array)
  return if array.empty?

  array.sum.fdiv(array.count)
end

def med(array)
  return if array.empty?

  count = array.count
  sorted = array.sort
  if count.odd?
    sorted[count / 2]
  else
    sorted[count / 2 - 1, 2].sum / 2.0
  end
end

def show_score_history(recs, max, total)
  recs = recs.reverse.take(total)
  scores = recs.map { |rec| rec[0].to_f }
  seconds = recs.map { |rec| rec[2].to_f }

  puts "#{max - 4}-\t#{max - 3}\t#{max - 2}\t#{max - 1}\t#{max}\tAve.\tMed.\tAve.Sec\tMed.Sec"
  puts [
    scores&.count { max - it >= 4 },
    scores&.count { max - it == 3 },
    scores&.count { max - it == 2 },
    scores&.count { max - it == 1 },
    scores&.count { max - it == 0 },
    ave(scores)&.round(2),
    med(scores)&.round(2),
    ave(seconds)&.round(2),
    med(seconds)&.round(2),
  ].join("\t")
end


full_recs = CSV.read('data/full.csv')
short_recs = CSV.read('data/short.csv')

puts 'Full'
show_score_history(full_recs, 30, 30)
puts nil
puts 'Short'
show_score_history(short_recs, 22, 30)
