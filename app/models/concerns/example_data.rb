module ExampleData extend ActiveSupport::Concern

  def populate_data(user)

    # Create a project
    project = create_and_get_new_project(user)

    # Create the phases and set phase 2 as current phase
    setup_phases(project)

    # Create the experiments
    setup_experiments(project)

    # Assign some experiments to sprints
    assign_experiments_to_sprints(project)

    # Create canvases
    create_canvases(project)

    # Create hypotheses for each area, with some assigned
    create_and_assign_hypotheses_to_areas(project)

    # Create some results
    create_results(project)

  end

  private

  def create_and_get_new_project(user)
    Project.create(
      name: 'Project example',
      description: 'Migas fingerstache pbr&b tofu. Polaroid distillery ' +
        'typewriter echo tofu actually. Slow-carb fanny pack pickled direct ' +
        'trade scenester mlkshk plaid. Banjo venmo chambray cold-pressed ' +
        'typewriter. Fap skateboard intelligentsia.',
      active: true,
      created_by: user
    )
  end

  def setup_phases(project)

    Project::PHASES.each_with_index do |phase, i|
      Phase.create(
        project: project,
        start_date: case i
        when 0
          Date.today - 30
        when 1
          Date.today
        else
          Date.today + 30
        end,
        sequence: i,
        number_of_sprints: case i
        when 0
          4
        when 1
          2
        else
          3
        end,
        sprint_length: case i
        when 0
          1
        when 1
          2
        else
          4
        end,
        completed: i == 0 ? true : false
      )
    end

    # Set phase 2 as current phase
    project.current_phase_id = (Phase.find_by(project: project, sequence: 1)).id
    project.save

  end

  def setup_experiments(project)
    project.phases.each do |p|
      4.times do |i|
        Experiment.create(
          phase: p,
          name: "experiment title #{i + 1}",
          description: 'Migas fingerstache pbr&b tofu. Polaroid distillery ' +
            'typewriter echo tofu actually. Slow-carb fanny pack pickled direct ' +
            'trade scenester mlkshk plaid. Banjo venmo chambray cold-pressed ' +
            'typewriter. Fap skateboard intelligentsia.',
          completed: p.sequence == 0,
          interviews_planned: i * 3,
          interviews_done: p.sequence == 1 ? (i * 2) : 0,
          early_adopters_planned: i * 10,
          early_adopters_converted: p.sequence == 1 ? (i * 9) : 0
        )
      end
    end
  end

  def assign_experiments_to_sprints(project)
    project.phases.each do |p|
      phase_experiments = Experiment.where(phase: p)
      case p.sequence
      when 0 # 4 sprints
        p.sprints.each_with_index do |s, i|
          phase_experiments.each_with_index do |e, j|
            if (i <= 1) && (j <= 1)
              s.experiments << e
              s.save
            elsif (i > 1) && (j > 1)
              s.experiments << e
              s.save
            end
          end
        end
      when 1 # 2 sprints
        p.sprints.each_with_index do |s, i|
          phase_experiments.each_with_index do |e, j|
            if (i == 0) && (j <= 1)
              s.experiments << e
              s.save
            elsif (i == 1) && (j > 1)
              s.experiments << e
              s.save
            end
          end
        end
      end
    end
  end

  def create_canvases(project)
    3.times do |i|
      Canvas.create(
        project: project,
        name: "This is the canvas name #{i + 1}",
        description: 'Migas fingerstache pbr&b tofu. Polaroid distillery ' +
          'typewriter echo tofu actually. Slow-carb fanny pack pickled direct ' +
          'trade scenester mlkshk plaid. Banjo venmo chambray cold-pressed ' +
          'typewriter. Fap skateboard intelligentsia.',
        customers_to_break_even: rand(100..10000),
        payback_period: rand(0.5..3),
        gross_margin: rand(100000..1000000),
        market_size: rand(2300000..40000000),
        customer_pain_level: rand(0..4),
        market_ease_of_reach: rand(0..4),
        feasibility: rand(0..4),
        riskiness: rand(0..4),
      )
    end
  end

  def create_and_assign_hypotheses_to_areas(project)
    project.canvases.each do |c|
      c.areas.each do |a|
        5.times do |i|
          h = Hypothesis.create(
            area_identifier: a.area_identifier,
            project: project,
            name: "This is the Hypothesis #{c.id}.#{a.id}.#{i}, area #{a.area_identifier}",
            description: 'Migas fingerstache pbr&b tofu. Polaroid distillery ' +
              'typewriter echo tofu actually. Slow-carb fanny pack pickled direct ' +
              'trade scenester mlkshk plaid. Banjo venmo chambray cold-pressed ' +
              'typewriter. Fap skateboard intelligentsia.'
          )
          a.hypotheses << h if i <= 3
        end
        a.save
      end
    end
  end

  def create_results(project)
    project.phases.each do |p|
      case p.sequence
      when 0 # 4 sprints
        experiments = p.assigned_experiments
        experiments.each_with_index do |e, i|
          project.canvases[0].areas.each_with_index do |a, x|
            a.hypotheses.each_with_index do |h, y| # 4 assigned hypotheses
              Result.create(
                experiment: experiments[i],
                hypothesis: a.hypotheses[y],
                comment: 'Migas fingerstache pbr&b tofu. Polaroid distillery ' +
                  'typewriter echo tofu actually. Slow-carb fanny pack pickled direct ' +
                  'trade scenester mlkshk plaid. Banjo venmo chambray cold-pressed ' +
                  'typewriter. Fap skateboard intelligentsia.',
                level: rand(0..4)
              )
            end
          end
        end
      when 1 # 2 sprints
        experiments = p.assigned_experiments
        experiments.each_with_index do |e, i|
          project.canvases[0].areas.each_with_index do |a, x|
            a.hypotheses.each_with_index do |h, y| # 4 assigned hypotheses
              if i < 3 # leave one hypothesis out
                Result.create(
                  experiment: experiments[i],
                  hypothesis: a.hypotheses[y],
                  comment: 'Migas fingerstache pbr&b tofu. Polaroid distillery ' +
                    'typewriter echo tofu actually. Slow-carb fanny pack pickled direct ' +
                    'trade scenester mlkshk plaid. Banjo venmo chambray cold-pressed ' +
                    'typewriter. Fap skateboard intelligentsia.',
                  level: rand(0..4)
                )
              end
            end
          end
        end
      end
    end
  end

end
