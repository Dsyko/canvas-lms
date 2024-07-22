/*
 * Copyright (C) 2024 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

/*
 * Copyright (C) 2024 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import React from 'react'
import {render} from '@testing-library/react'
import {Editor, Frame} from '@craftjs/core'
import {Container} from '../../../blocks/Container'
import {ColumnsSection, type ColumnsSectionProps} from '..'
import {NoSections} from '../../../common'

const renderSection = (props: Partial<ColumnsSectionProps> = {}) => {
  return render(
    <Editor enabled={true} resolver={{ColumnsSection, NoSections, Container}}>
      <Frame>
        <ColumnsSection columns={2} {...props} />
      </Frame>
    </Editor>
  )
}

describe('ColumnsSection', () => {
  it('should render fixed variant by default', () => {
    const {container} = renderSection()
    expect(container.querySelector('.section.columns-section.fixed.columns-2')).toBeInTheDocument()
    expect(container.querySelectorAll('.columns-section__inner')).toHaveLength(2)
  })

  it('should render fluid variant', () => {
    const {container} = render(
      <Editor enabled={true} resolver={{ColumnsSection, NoSections, Container}}>
        <Frame>
          <ColumnsSection columns={3} variant="fluid" />
        </Frame>
      </Editor>
    )
    expect(container.querySelector('.section.columns-section.fluid.columns-3')).toBeInTheDocument()
    expect(container.querySelectorAll('.columns-section__inner')).toHaveLength(1)
  })

  it('is tagged as a section', () => {
    expect(ColumnsSection.craft.custom.isSection).toBe(true)
  })

  it('has a section menu', () => {
    expect(ColumnsSection.craft.related.sectionMenu).toBeDefined()
  })
})
