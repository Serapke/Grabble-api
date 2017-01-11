
FactoryGirl.define do
	factory :user do
		nickname "Grabble Rookie"

		factory :scorer1000 do
			nickname "scorer1000"
			score 1000
			place 1
		end

		factory :scorer100 do
			nickname "scorer100"
			score 100
			place 2
		end

		factory :scorer10 do
			nickname "scorer10"
			score 10
			place 3
		end
	end
end
