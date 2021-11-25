# frozen_string_literal: true

#
# Copyright (C) 2011 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module Lti
  class ResourcePlacement < ActiveRecord::Base
    ACCOUNT_NAVIGATION = 'account_navigation'
    ASSIGNMENT_EDIT = 'assignment_edit'
    ASSIGNMENT_SELECTION = 'assignment_selection'
    ASSIGNMENT_VIEW = 'assignment_view'
    COURSE_NAVIGATION = 'course_navigation'
    LINK_SELECTION = 'link_selection'
    POST_GRADES = 'post_grades'
    RESOURCE_SELECTION = 'resource_selection'
    SIMILARITY_DETECTION = 'similarity_detection'
    GLOBAL_NAVIGATION = 'global_navigation'

    SIMILARITY_DETECTION_LTI2 = 'Canvas.placements.similarityDetection'

    # Default placements for LTI 1 and LTI 2, ignored for LTI 1.3
    LEGACY_DEFAULT_PLACEMENTS = [ASSIGNMENT_SELECTION, LINK_SELECTION].freeze

    PLACEMENTS = %i[account_navigation
                    similarity_detection
                    assignment_edit
                    assignment_menu
                    assignment_index_menu
                    assignment_group_menu
                    assignment_selection
                    assignment_view
                    collaboration
                    conference_selection
                    course_assignments_menu
                    course_home_sub_navigation
                    course_navigation
                    course_settings_sub_navigation
                    discussion_topic_menu
                    discussion_topic_index_menu
                    editor_button
                    file_menu
                    file_index_menu
                    global_navigation
                    homework_submission
                    link_selection
                    migration_selection
                    module_menu
                    module_group_menu
                    module_index_menu
                    module_index_menu_modal
                    post_grades
                    quiz_menu
                    quiz_index_menu
                    resource_selection
                    submission_type_selection
                    student_context_card
                    tool_configuration
                    user_navigation
                    wiki_index_menu
                    wiki_page_menu].freeze

    PLACEMENT_LOOKUP = {
      'Canvas.placements.accountNavigation' => ACCOUNT_NAVIGATION,
      'Canvas.placements.assignmentEdit' => ASSIGNMENT_EDIT,
      'Canvas.placements.assignmentSelection' => ASSIGNMENT_SELECTION,
      'Canvas.placements.assignmentView' => ASSIGNMENT_VIEW,
      'Canvas.placements.courseNavigation' => COURSE_NAVIGATION,
      'Canvas.placements.linkSelection' => LINK_SELECTION,
      'Canvas.placements.postGrades' => POST_GRADES,
      SIMILARITY_DETECTION_LTI2 => SIMILARITY_DETECTION,
    }.freeze

    belongs_to :message_handler, class_name: 'Lti::MessageHandler'
    belongs_to :resource_handler, class_name: 'Lti::ResourceHandler'
    validates :message_handler, :placement, presence: true

    validates :placement, inclusion: { in: PLACEMENT_LOOKUP.values }

    def self.valid_placements(_root_account)
      PLACEMENTS.dup.tap do |p|
        p.delete(:conference_selection) unless Account.site_admin.feature_enabled?(:conference_selection_lti_placement)
      end
    end

    def self.update_tabs_and_return_item_banks_tab(tabs, new_label = nil)
      item_banks_tab = tabs.find { |t| t[:label] == 'Item Banks' }
      if item_banks_tab
        item_banks_tab[:label] = new_label || t('#tabs.item_banks', 'Item Banks')
      end
      item_banks_tab
    end
  end
end
