LOCALISATIONS = {
  en: YAML.load_file('spec/support/locales/sample.en.yaml')
}.freeze

shared_examples 'a field that supports setting the label via localisation' do
  let(:localisations) { LOCALISATIONS }

  context 'localising when no text is supplied' do
    let(:localisation_key) do
      defined?(value) ? "#{attribute}_options.#{value}" : attribute
    end

    let(:expected_label) do
      I18n.translate(localisation_key, scope: 'helpers.label.person')
    end

    subject { builder.send(*args) }

    specify 'should set the label from the locales' do
      with_localisations(localisations) do
        # wrap label assertation in a regexp because the caption is placed alongside the text
        expect(subject).to have_tag('label', text: Regexp.new(expected_label))
      end
    end
  end

  context 'allowing localised text to be overridden' do
    let(:expected_label) { "Yeah but, who are you really?" }

    subject { builder.send(*args, label: { text: expected_label }) }

    specify 'should use the supplied label text' do
      with_localisations(localisations) do
        # wrap label assertation in a regexp because the caption is placed alongside the text
        expect(subject).to have_tag('label', text: Regexp.new(expected_label))
      end
    end
  end

  context 'allowing localised text to be suppressed' do
    subject do
      builder.send(*args, label: nil)
    end

    specify 'no label should be rendered' do
      with_localisations(localisations) do
        expect(subject).not_to have_tag('label')
      end
    end
  end
end

shared_examples 'a nested field that supports setting the label via localisation' do
  context 'when the localised field is nested' do
    let(:attribute) { :number_and_street }

    subject do
      builder.fields_for(:address, builder: described_class) { |af| af.send(*args) }
    end

    let(:localisations) { { en: YAML.load_file('spec/support/locales/sample.en.yaml') } }
    let(:expected_text) { I18n.translate("number_and_street", scope: "helpers.label.person.address") }

    specify "finds the correct nested localisation" do
      with_localisations(localisations) do
        expect(subject).to have_tag("label", text: expected_text, with: { class: "govuk-label" })
      end
    end
  end
end

shared_examples 'a field that supports setting the label caption via localisation' do
  let(:localisations) { LOCALISATIONS }

  context 'localising when no text is supplied' do
    let(:localisation_key) { attribute }

    let(:expected_caption) do
      I18n.translate(localisation_key, scope: 'helpers.caption.person')
    end

    subject { builder.send(*args) }

    specify 'should set the caption from the locales' do
      with_localisations(localisations) do
        expect(subject).to have_tag('span', text: expected_caption)
      end
    end
  end

  context 'allowing localised text to be overridden' do
    let(:expected_caption) { "Private data" }

    subject { builder.send(*args, caption: { text: expected_caption }) }

    specify 'should use the supplied caption text' do
      with_localisations(localisations) do
        expect(subject).to have_tag('span', text: expected_caption, with: { class: "govuk-caption-m" })
      end
    end
  end

  context 'allowing localised text to be suppressed' do
    let(:expected_caption) { "Private data" }

    subject do
      builder.send(*args, caption: nil)
    end

    specify 'no caption should be rendered' do
      with_localisations(localisations) do
        expect(subject).not_to have_tag('span', with: { class: "govuk-caption-m" })
      end
    end
  end
end

shared_examples 'a field that supports setting the legend caption via localisation' do
  let(:localisations) { LOCALISATIONS }

  context 'localising when no text is supplied' do
    let(:localisation_key) { attribute }

    let(:expected_caption) do
      I18n.translate(localisation_key, scope: 'helpers.caption.person')
    end

    subject { builder.send(*args) }

    specify 'should set the caption from the locales' do
      with_localisations(localisations) do
        expect(subject).to have_tag('span', text: expected_caption)
      end
    end
  end

  context 'allowing localised text to be overridden' do
    let(:expected_caption) { "Private data" }

    subject { builder.send(*args, caption: { text: expected_caption }) }

    specify 'should use the supplied caption text' do
      with_localisations(localisations) do
        expect(subject).to have_tag('span', text: expected_caption)
      end
    end
  end

  context 'allowing localised text to be suppressed via the legend' do
    subject do
      builder.send(*args, legend: nil)
    end

    specify 'no caption should be rendered' do
      with_localisations(localisations) do
        expect(subject).not_to have_tag('span', with: { class: "govuk-caption-m" })
      end
    end
  end
end

shared_examples 'a field that supports setting the hint via localisation' do
  let(:arbitrary_html_content) { builder.tag.p("a wild paragraph has appeared") }
  let(:localisations) { LOCALISATIONS }

  context 'localising when no text is supplied' do
    let(:expected_hint) do
      if defined?(value) && value.present?
        I18n.translate("helpers.hint.person.#{attribute}_options.#{value}")
      else
        I18n.translate("helpers.hint.person.#{attribute}")
      end
    end

    subject { builder.send(*args) { arbitrary_html_content } }

    specify 'should set the hint from the locales' do
      with_localisations(localisations) do
        expect(subject).to have_tag('div', text: expected_hint, with: { class: 'govuk-hint' })
      end
    end
  end

  context 'allowing localised text to be overridden' do
    let(:expected_hint) { "It's quite a straightforward question!" }

    subject do
      builder.send(*args, hint: { text: expected_hint }) { arbitrary_html_content }
    end

    specify 'should use the supplied hint text' do
      with_localisations(localisations) do
        expect(subject).to have_tag('div', text: expected_hint, with: { class: 'govuk-hint' })
      end
    end
  end

  context 'allowing localised text to be suppressed' do
    subject do
      builder.send(*args, hint: nil) { arbitrary_html_content }
    end

    specify 'no hint should be rendered' do
      with_localisations(localisations) do
        expect(subject).not_to have_tag('div', with: { class: 'govuk-hint' })
      end
    end
  end
end

shared_examples 'a field that supports setting the legend via localisation' do
  let(:arbitrary_html_content) { builder.tag.p("a wild paragraph has appeared") }
  let(:localisations) { LOCALISATIONS }

  context 'localising when no text is supplied' do
    let(:expected_legend) { I18n.translate("helpers.legend.person.#{attribute}") }
    subject { builder.send(*args) { arbitrary_html_content } }

    specify 'should set the legend from the locales' do
      with_localisations(localisations) do
        expect(subject).to have_tag('fieldset') do
          with_tag('legend', text: Regexp.new(expected_legend), with: { class: 'govuk-fieldset__legend' })
        end
      end
    end
  end

  context 'allowing localised text to be overridden' do
    let(:expected_legend) { "It is quite a straightforward question!" }
    subject { builder.send(*args, legend: { text: expected_legend }) { arbitrary_html_content } }

    specify 'should set the legend from the locales' do
      with_localisations(localisations) do
        expect(subject).to have_tag('fieldset') do
          with_tag('legend', text: Regexp.new(expected_legend), with: { class: 'govuk-fieldset__legend' })
        end
      end
    end
  end

  context 'allowing localised text to be suppressed' do
    subject { builder.send(*args, legend: nil) { arbitrary_html_content } }

    specify 'no legend should be rendered' do
      with_localisations(localisations) do
        expect(subject).not_to have_tag('legend')
      end
    end
  end
end

shared_examples 'a field that allows the label to be localised via a proc' do
  let(:locale) { :de }
  let(:localisations) do
    YAML.load_file('spec/support/locales/colours.de.yaml')
  end

  context 'localising collection items using procs' do
    subject { builder.send(*args) }

    specify 'labels should be present and correctly-localised' do
      with_localisations({ locale => localisations }, locale: locale) do
        colours.each do |c|
          expect(subject).to have_tag(
            'label',
            text: localisations.dig("colours", c.name.downcase),
            with: { class: 'govuk-label' }
          )
        end
      end
    end
  end
end

shared_examples 'a field that allows the hint to be localised via a proc' do
  let(:locale) { :de }
  let(:localisations) do
    YAML.load_file('spec/support/locales/colours.de.yaml')
  end

  context 'localising collection items using procs' do
    subject { builder.send(*args) }

    specify 'hints should be present and correctly-localised' do
      with_localisations({ locale => localisations }, locale: locale) do
        colours.each do |c|
          expect(subject).to have_tag(
            'div',
            text: localisations.dig("colours", c.name.downcase),
            with: { class: 'govuk-hint' }
          )
        end
      end
    end
  end
end

shared_examples 'a field that supports localised collection labels' do
  let(:localisations) { LOCALISATIONS }
  let(:attribute) { :department }
  subject { builder.send(*args) }

  specify 'the labels should be set by localisation' do
    with_localisations(localisations) do
      departments.each do |department|
        expected_label = I18n.translate(department.code, scope: 'helpers.label.person.department_options')
        expect(subject).to have_tag('label', text: expected_label)
      end
    end
  end
end

shared_examples 'a field that supports localised collection hints' do
  let(:localisations) { LOCALISATIONS }
  let(:attribute) { :department }
  subject { builder.send(*args) }

  specify 'the hints should be set by localisation' do
    with_localisations(localisations) do
      departments.each do |department|
        expected_hint = I18n.translate(department.code, scope: 'helpers.hint.person.department_options', default: nil)

        if expected_hint.present?
          expect(subject).to have_tag('div', with: { class: %w(govuk-hint).append(hint_class) }, text: expected_hint)
        end
      end

      # testing that the correct hint (sales) is missing is a bit 'involved',
      # so now we've ensured that the ones we expect to be there are present
      # let's make sure they're the only ones that are by counting them
      departments_with_localised_hints = departments.count do |department|
        I18n.translate(department.code, scope: 'helpers.hint.person.department_options', default: nil)
      end

      expect(subject).to have_tag('div', with: { class: %w(govuk-hint).append(hint_class) }, count: departments_with_localised_hints)
    end
  end
end

shared_examples 'a field that supports localised fieldset hints' do
  let(:localisations) { { en: YAML.load_file('spec/support/locales/collection_hints.en.yaml').deep_symbolize_keys } }
  let(:expected_hints) { localisations.dig(:en, :helpers, :hint, :person, localisation_key) }

  specify 'the hints should be set by localisation' do
    with_localisations(localisations) do
      expected_hints.each do |id, hint|
        expected_id = ["person", field_name_selector, id, "hint"].join("-")
        expect(subject).to have_tag("div", with: { id: expected_id }, text: hint)
      end
    end
  end
end
