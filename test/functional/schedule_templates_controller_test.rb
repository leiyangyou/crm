require 'test_helper'

class ScheduleTemplatesControllerTest < ActionController::TestCase
  setup do
    @schedule_template = schedule_templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedule_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schedule_template" do
    assert_difference('ScheduleTemplate.count') do
      post :create, schedule_template: { attributes: @schedule_template.attributes, template: @schedule_template.template }
    end

    assert_redirected_to schedule_template_path(assigns(:schedule_template))
  end

  test "should show schedule_template" do
    get :show, id: @schedule_template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @schedule_template
    assert_response :success
  end

  test "should update schedule_template" do
    put :update, id: @schedule_template, schedule_template: { attributes: @schedule_template.attributes, template: @schedule_template.template }
    assert_redirected_to schedule_template_path(assigns(:schedule_template))
  end

  test "should destroy schedule_template" do
    assert_difference('ScheduleTemplate.count', -1) do
      delete :destroy, id: @schedule_template
    end

    assert_redirected_to schedule_templates_path
  end
end
