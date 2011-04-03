# -*- coding: utf-8 -*-
class ActivitiesController < ApplicationController

  # GET /activities/new
  # GET /activities/new.xml
  def new
    @course = Course.find(params[:course_id])
    @activity = @course.activities.build
    80.times { @activity.participants.build }
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /activities/1/edit
  def edit
    @course = Course.find(params[:course_id])
    @activity = Activity.find(params[:id])
    20.times { @activity.participants.build }
    @participants = Participant.find_all_by_activity_id(@activity.id)
    @javascript_variable = "["
    @participants.each do |p|
      if @participants.last.id != p.id
        @javascript_variable << "{name: '#{p.name}', group: '#{p.group}', unit: '#{p.unit}', contact: '#{p.contact}'},"
      else
        @javascript_variable << "{name: '#{p.name}', group: '#{p.group}', unit: '#{p.unit}', contact: '#{p.contact}'}]"
      end
    end
  end

  # POST /activities
  # POST /activities.xml
  def create
    @course = Course.find(params[:course_id])
    @activity = @course.activities.build(params[:activity])
    respond_to do |format|
      if @activity.save
        format.html { redirect_to( course_path(params[:course_id]), :notice => 'Lista de presença salva com sucesso') }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        80.times { @activity.participants.build }
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /activities/1
  # PUT /activities/1.xml
  def update
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to( course_path(params[:course_id]), :notice => 'Lista de presença salva com sucesso') }
        format.html { redirect_to(@activity, :notice => 'activity was successfully updated.') }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.xml
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy

    respond_to do |format|
      format.html { redirect_to(course_path(params[:course_id])) }
      format.xml  { head :ok }
    end
  end
end

