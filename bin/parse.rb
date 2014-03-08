#!/usr/bin/env ruby

require 'csv'
require 'xmlsimple'

file = ARGV[0] || 'input.xml'
output = ARGV[1] || 'output.csv'

patients = XmlSimple.xml_in(file, 'KeyAttr' => 'id_pac')['is'][0]['ip']

CSV.open(output,'wb', external_encoding: 'cp1250') do |csv|
  csv << %w{rodcis jmeno prijmeni sex dat_nar kodpoj text}

  patients.each do |k,v|
    rodcis = v['rodcis'][0]
    jmeno = v['jmeno'][0]
    prijmeni = v['prijmeni'][0]
    sex = v['sex'][0]
    dat_nar = v['dat_dn'][0]['content']
    kodpoj = v['pv'][0]['p'][0]['kodpoj'][0]
    text =  v['v'][0]['vr'][0]['vrb'][0]['text'][0]['ptext'][0]['content']
    text.gsub!("\n",'//')
    text.gsub!(%r{//\s*//},'//')
    text.gsub!(%r{\A\s*//},'')
    text.gsub!(%r{//\s*\z},'')
    text.gsub!(/\s{2,}/,' ')
    text.gsub!('// ','//')

    out = [rodcis,jmeno,prijmeni,sex,dat_nar,kodpoj,text]
    # p out

    # puts

    csv << out
  end
end
