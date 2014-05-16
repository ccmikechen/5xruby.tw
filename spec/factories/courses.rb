# == Schema Information
#
# Table name: courses
#
#  id              :integer          not null, primary key
#  image           :string(255)
#  title           :string(255)      not null
#  summary         :text
#  description     :text
#  what_will_learn :text
#  created_at      :datetime
#  updated_at      :datetime
#  subtitle        :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    image { Faker::Image.image }
    title { Faker::Name.title }
    subtitle { Faker::Lorem.sentence }
    summary { "<p>#{Faker::Lorem.paragraph}</p>" }
    description { "<p>#{Faker::Lorem.paragraph}</p>" }
    what_will_learn { "<p>#{Faker::Lorem.paragraph}</p>" }

    ignore do
      stages_count 6
      applies_count 3
    end

    after(:build) do |course, evaluator|
      stages = build_list(:stage, evaluator.stages_count)
      stages.each_with_index{|s, i| s.sort_id = i}
      course.stages = stages
    end

    after(:create) do |course, evaluator|
      Schedule.includes(:stage).where(stages: {course_id: course}).each do |schedule|
        create_list(:apply, evaluator.applies_count, course: course, stage: schedule.stage, schedule: schedule)
      end
    end
  end
end