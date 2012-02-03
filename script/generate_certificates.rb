Certificate.delete_all

courses = Course.all(:conditions => "id IN (32, 3, 1, 2, 15, 17, 16, 11, 22)")

courses.each do |course|
  participants = Participant.all(:conditions => "course_id = #{course.id}")
  activities_ids = course.activities.collect(&:id).join(',')
  activities_total = 0
  participant = nil
  participants.each do |p|
    participant_total_activities = ActivitiesParticipant.all(:conditions => "activity_id IN (#{activities_ids}) AND participant_id = #{p.id}").count
    
    if participant_total_activities > activities_total
      activities_total = participant_total_activities 
      participant = p
    end

  end

  duration = 0
  activities = Activity.find_by_sql("SELECT a.* FROM activities a 
    WHERE ID IN (SELECT activity_id FROM activities_participants ap WHERE ap.activity_id IN (#{activities_ids}) AND participant_id = #{participant.id})")
  activities.each do |a|
    duration += a.duration
  end

  data = []
  export_data = []
  participants.each do |p|
    a = ActivitiesParticipant.all(:conditions => "activity_id IN (#{activities_ids}) AND participant_id = #{p.id}").collect(&:activity_id)
    activities = Activity.all(:conditions => "id IN (#{a.join(',')})")
    hours = 0
    activities.each do |a|
      hours += a.duration
    end
    frequency = (hours * 100)/duration
    if frequency > 100
      frequency = 100
    end
    data << [p.id, course.id, frequency, hours, duration]
    export_data << [p.name, course.identifier, frequency, hours, duration, course.description]
  end

  data.each do |d|
    Certificate.create({
      :total_hours => d[3],
      :frequency => d[2],
      :participant_id => d[0],
      :course_id => d[1],
      :course_total_hours => d[4]
    })
  end

  file_name = 'dados_dos_certificados'
  reference_code = course.reference_code.gsub(' ', '').gsub('(', '').gsub(')', '')
  FasterCSV.open("public/#{file_name}_#{reference_code}.csv", "w") do |csv|
    csv << ["Nome do participante", "Titulo de exibição no certificado",
      "Porcentagem de Frequência", "Total de horas", "Carga horária do curso" "Ementa"]
    export_data.each do |d|
      csv << d
    end
  end


end