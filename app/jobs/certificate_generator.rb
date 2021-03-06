# -*- encoding : utf-8 -*-

class CertificateGenerator
  @queue = :certificate_generator
  FOR_COURSE = 1
  FOR_PARTICIPANT = 2
  def self.perform(action, id)
    info = Util::Log.new(:prefix=>"CERTIFICATE_GENERATOR")
    case action
      when FOR_COURSE then for_course(id, info)
      when FOR_PARTICIPANT then for_participant(id, info)
    end
  end

private

  def self.for_participant(participant_id, info)
    participant = Participant.find(participant_id)
    info.log "Iniciada geração do certificado para o participante com id #{participant.id}"
    participant.certificates {|c| c.destroy}
    course = participant.course
    directory = "#{RAILS_ROOT}/public/certificates/#{course.id}"
    Dir.mkdir(directory) if !File.directory?(directory)
    frequency = participant.frequency
    file_name = "#{course.id}_#{clean_string(participant.name)}.pdf"
    certificate = create_certificate_for_participant(:participant => participant, :course => course,
      :course_total_time => course.total_hours, :frequency => frequency, :file_name => file_name)
    info.log "Finalizada geração do certificado para o participante com id #{participant.id}"
    info.log "O certificado foi gerado em: #{RAILS_ROOT}/public/certificates/#{course.id}/#{file_name}"
    #puts is_email?(participant.contact)
    #Resque.enqueue(CertificateSender,certificate.id, 'ffc.fabricio@gmail.com', false) if is_email?('ffc.fabricio@gmail.com')
  end

  def self.create_certificate_for_participant(params={})
    c = Certificate.new(
      :participant => params[:participant],
      :course => params[:course],
      :total_hours => params[:course_total_time],
      :frequency => params[:frequency],
      :period => "#{params[:course].start_date.strftime("%d/%m/%Y")} à #{params[:course].end_date.strftime("%d/%m/%Y")}",
      :file_path => "#{RAILS_ROOT}/public/certificates/#{params[:course].id}/#{params[:file_name]}")
    c.save
#    c.save_file
    c
  end

  def self.calc_frequency(participant_total_time, course_total_time)
    frequency = course_total_time > 0 ? ((participant_total_time*100)/course_total_time.to_f).floor : 0
    frequency = frequency < 0 ? -frequency : frequency
  end

  def self.clean_string(string)
    string.remover_acentos.downcase.gsub(' ', '_')
  end

  def self.is_email?(string)
    !(string.match(/^([^@s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})$/i)).nil?
  end
end

